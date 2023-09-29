import 'package:color_blast/Model/booking.dart';
import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Service/service_booking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';

import 'booking_details_page.dart';




class PlanningPage extends StatefulWidget {
  const PlanningPage({Key? key}) : super(key: key);

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  List<Booking?>? booking = [];
  bool isLoading = false;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    getBooking().then((_) {
      _createEventsFromBookings(booking);
    });
  }


  List<Event> _events = [];

  void _createEventsFromBookings(List<Booking?>? bookings) {
    _events.clear();

    if (bookings != null) {
      for (var booking in bookings) {
        print("debut");
        print(booking?.booking.dhDebut);
        print("fin");
        print(booking?.booking.dhFin);
        if (booking != null) {
          _events.add(Event(booking));
        }
      }
    }
  }



  // Dans PlanningPage
  Future<void> _showBookingInfoDialog(BuildContext context, Booking booking) async {
    final updated = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BookingInfoDialog(booking: booking, onUpdate: () async {
          // Mettre à jour la liste des réservations
          await getBooking();
          // Renvoyer true pour indiquer la mise à jour
          return true;
        });
      },
    );

    if (updated != null && updated is bool && updated) {
      // La popup a été mise à jour, vous pouvez effectuer des actions supplémentaires si nécessaire.
    }
  }


  List<Event> _getEventsForDay(DateTime date) {
    final events = _events.where((event) {
      final booking = event.booking;
      return booking.booking.dhDebut.isBefore(date) && booking.booking.dhFin.add(Duration(days: 1)).isAfter(date);
    }).toList();

    return events;
  }



  Future<void> getBooking() async {
    setState(() {
      isLoading = true;
    });

    if(DataManager().workspaceClient == true){
      booking = await ServiceBooking().getBookingByIdClientWithWaitingFalse(DataManager().client?.id);
    }else{
      booking = await ServiceBooking().getBookingByIdProWithWaitingFalse(DataManager().pro?.pro.id);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Votre planning"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepOrange,
                Colors.orange,
                Colors.orangeAccent,
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : TableCalendar(
          firstDay: DateTime.utc(2021, 1, 1),
          lastDay: DateTime.utc(2025, 12, 31),
          focusedDay: _focusedDay,
          eventLoader: (date) => _getEventsForDay(date),
          headerStyle: const HeaderStyle(
            titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            formatButtonVisible: false,
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            markerDecoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });

            final eventsForDay = _getEventsForDay(selectedDay);
            if (eventsForDay.isNotEmpty) {
              _showBookingInfoDialog(context, eventsForDay[0].booking);
            }
          },
        ),
      ),


    );
  }
}


class EventIndicator extends StatelessWidget {
  final Color color;

  EventIndicator({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}


class Event {
  final Booking booking;

  Event(this.booking);
}


class BookingInfoDialog extends StatelessWidget {
  final Booking booking;
  final Function onUpdate;

  BookingInfoDialog({required this.booking, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Détails de la réservation',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Nom du client : ${booking.booking.lastname} ${booking.booking.firstname}',
            ),
          ),
          ListTile(
            leading: Icon(Icons.location_city),
            title: Text('Ville : ${booking.booking.city}'),
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Adresse : ${booking.booking.address}'),
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Catégorie : ${booking.booking.category}'),
          ),
          ListTile(
            leading: Icon(Icons.crop_square),
            title: Text('Surface : ${booking.booking.surface} m²'),
          ),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text('Date de début : ${booking.booking.dhDebut.day}/${booking.booking.dhDebut.month}/${booking.booking.dhDebut.year}'),
          ),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text('Date de fin : ${booking.booking.dhFin.day}/${booking.booking.dhFin.month}/${booking.booking.dhFin.year}'),
          ),


        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final updated = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingDetailsPage(booking: booking, context: true,),
              ),
            );

            if (updated != null && updated is bool && updated) {
              // Utilisez le callback onUpdate pour mettre à jour la liste et fermer la popup
              final shouldUpdate = await onUpdate();
              if (shouldUpdate) {
                Navigator.of(context).pop(true);
              }
            }
          },
          child: Text('Détails'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Fermer'),
        ),
      ],
    );
  }
}



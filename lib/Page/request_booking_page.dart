import 'package:flutter/material.dart';

import '../Model/booking.dart';
import '../Model/data_manager.dart';
import '../Service/service_booking.dart';
import 'booking_details_page.dart';

class RequestBookingPage extends StatefulWidget {
  const RequestBookingPage({Key? key}) : super(key: key);

  @override
  State<RequestBookingPage> createState() => _RequestBookingPageState();
}

class _RequestBookingPageState extends State<RequestBookingPage> {
  List<Booking?>? booking;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDatas();
  }

  Future<void> getDatas() async {
    if(DataManager().workspaceClient == true){
      booking = await ServiceBooking().getBookingByIdClientWithWaitingTrue(DataManager().client?.id);

    }else{
      booking = await ServiceBooking().getBookingByIdProWithWaitingTrue(DataManager().pro?.pro.id);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demandes de devis"),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Afficher le spinner
          : Container(
            height: 500, // Ajustez cette valeur selon vos besoins
            child: ListView.builder(
              itemCount: booking!.length,
              itemBuilder: (context, index) {
            final currentBooking = booking![index];
            final hasQuote = currentBooking?.quote != null;


              return ListTile(
                title: Text('${currentBooking?.booking.firstname} ${currentBooking?.booking.lastname}'),
                subtitle: Text('${currentBooking?.booking.city}, ${currentBooking?.booking.address}'),
                trailing: hasQuote
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 4.0),
                  ],
                )
                    : null,
                onTap: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailsPage(booking: currentBooking, context: false,),
                    ),
                  );

                  if (updated != null && updated is bool && updated) {
                    getDatas();
                  }
                },
              );
          },
        ),
      ),
    );
  }
}

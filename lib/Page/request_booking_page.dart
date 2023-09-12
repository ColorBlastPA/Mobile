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

  bool isLoading = true; // Pour afficher le spinner

  @override
  void initState() {
    super.initState();
    getDatas();
  }

  Future<void> getDatas() async {
    booking = await ServiceBooking().getBookingByIdProWithWaitingTrue(DataManager().pro?.pro.id);

    // Une fois la requête terminée, arrêtez le chargement et mettez à jour l'interface utilisateur.
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
          : booking == null || booking!.isEmpty
          ? Center(child: Text('Vous n\'avez aucune demande de devis'))
          : ListView.builder(
        itemCount: booking!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${booking![index]?.booking.firstname} ${booking![index]?.booking.lastname}'),
            subtitle: Text('${booking![index]?.booking.city}, ${booking![index]?.booking.address}'),
            onTap: () {
              // Naviguez vers une nouvelle page pour afficher les détails du booking
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingDetailsPage(booking: booking![index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

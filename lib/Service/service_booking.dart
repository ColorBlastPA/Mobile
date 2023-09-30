import 'dart:convert';

import 'package:color_blast/Model/booking.dart';
import 'package:http/http.dart' as http;

class ServiceBooking{
  Future<List<Booking?>?> getBookingByIdClientWithWaitingFalse(int? idClient) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/bookings/client/${idClient}/notwaiting');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return bookingFromJson(json);
    }
    return null;
  }

  Future<List<Booking?>?> getBookingByIdProWithWaitingFalse(int? idPro) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/bookings/pro/${idPro}/notwaiting');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return bookingFromJson(json);
    }
    return null;
  }

  Future<List<Booking?>?> getBookingByIdProWithWaitingTrue(int? idPro) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/bookings/pro/${idPro}/waiting');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return bookingFromJson(json);
    }
    return null;
  }

  Future<List<Booking?>?> getBookingByIdClientWithWaitingTrue(int? idClient) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/bookings/client/${idClient}/waiting');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return bookingFromJson(json);
    }
    return null;
  }

  Future<int> updateBooking(int id, BookingClass updatedBooking) async {
    final response = await http.put(
      Uri.parse('https://api-colorblast.current.ovh/bookings/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedBooking.toJson()),
    );
    return response.statusCode;
  }

  Future<http.Response> createBooking(BookingClass bookingClass) async {
    final response = await http.post(
      Uri.parse('https://api-colorblast.current.ovh/bookings'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "idClient": bookingClass.idClient,
        "idPro": bookingClass.idPro,
        "lastname": bookingClass.lastname,
        "firstname": bookingClass.firstname,
        "proLastname": bookingClass.proLastname,
        "proFirstname": bookingClass.proFirstname,
        "city": bookingClass.city,
        "address": bookingClass.address,
        "category": bookingClass.category,
        "surface": bookingClass.surface,
        "dhDebut": bookingClass.dhDebut.toIso8601String(),
        "dhFin": bookingClass.dhFin.toIso8601String(),
        "waiting": bookingClass.waiting
      }),
    );
    return response;
  }


  Future<void> createProductBooking(int idBooking, int idProduct) async {
    final response = await http.post(
      Uri.parse('https://api-colorblast.current.ovh/productbookings'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "idBooking": idBooking,
        "idProduct": idProduct
      }),
    );
  }

  Future<int> deleteBooking(int? id) async {
    final response = await http.delete(
      Uri.parse('https://api-colorblast.current.ovh/bookings/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response.statusCode;
  }

}
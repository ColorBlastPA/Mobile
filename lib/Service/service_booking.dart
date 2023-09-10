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
}
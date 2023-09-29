import 'dart:convert';

import 'package:color_blast/Model/planning.dart';
import 'package:http/http.dart' as http;

class ServicePlanning{


  Future<List<Planning?>?> getPlanningByIdClient(int? idClient) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/planning/client/${idClient}');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return planningFromJson(json);
    }
    return null;
  }

  Future<List<Planning?>?> getPlanningByIdPro(int? idPro) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/planning/pro/${idPro}');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return planningFromJson(json);
    }
    return null;
  }

  Future<http.Response> createPlanning(Planning planning) async {
    final response = await http.post(
      Uri.parse('https://api-colorblast.current.ovh/planning'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "idClient": planning.idClient,
        "idPro": planning.idPro,
        "idBooking": planning.idBooking,
        "ddate": planning.ddate.toIso8601String(),
        "fdate": planning.fdate.toIso8601String(),
        "actif": true
      }),
    );
    return response;
  }

  Future<int> deletePlanning(int? id) async {
    final response = await http.delete(
      Uri.parse('https://api-colorblast.current.ovh/planning/deleteByBookingId/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response.statusCode;
  }

}
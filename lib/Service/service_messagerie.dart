import 'dart:convert';

import 'package:color_blast/Model/messagerie.dart';
import 'package:http/http.dart' as http;

import '../Model/messaging_pro.dart';

class ServiceMessagerie{


  Future<List<MessagerieClient?>?> getMessageriesByIdClient(int? idClient) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/messagerie/client/${idClient}');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return messagerieFromJson(json);
    }
    return null;
  }

  Future<List<MessagingPro?>?> getMessageriesByIdPro(int? idClient) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/messagerie/client/${idClient}');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return messagingProFromJson(json);
    }
    return null;
  }

}
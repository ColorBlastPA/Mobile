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
      return messagerieListFromJson(json);
    }
    return null;
  }

  Future<MessagerieClient?> getMessageriesByIdClientAndPro(int? idClient, int? idPro) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/messagerie/get/${idClient}/${idPro}');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return messagerieFromJson(json);
    }
    return null;
  }

  Future<List<MessagingPro?>?> getMessageriesByIdPro(int? idClient) async{

    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/messagerie/pro/${idClient}');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return messagingProFromJson(json);
    }
    return null;
  }

  Future<int> createMessagerie(MessagerieClass messagerie) async {
    final response = await http.post(
      Uri.parse('https://api-colorblast.current.ovh/messagerie'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "idClient": messagerie.idClient,
        "idPro": messagerie.idPro,
        "lastMessage": messagerie.lastMessage,
        "dLastMessage": messagerie.dLastMessage.toIso8601String(),
      }),
    );

    if(response.statusCode==200){
      return response.statusCode;
    }else{
      return response.statusCode;
    }
  }

}
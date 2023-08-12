import 'dart:convert';

import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/messagerie.dart';
import 'package:color_blast/Model/professionnel.dart';
import 'package:http/http.dart' as http;

class ServiceMessagerie{


  Future<List<Messagerie?>?> getMessageriesByIdClient(int? idClient) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/messagerie/client/${idClient}');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return messagerieFromJson(json);
    }
    return null;
  }

}
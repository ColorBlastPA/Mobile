import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/line.dart';

class ServiceLine{

  Future<int> appendLine(Line line) async{

    var response = await http.post(
      Uri.parse('https://api-colorblast.current.ovh/lines'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'idMessagerie': line.idMessagerie,
        'mail': line.mail,
        'lastname': line.lastname,
        'firstname': line.firstname,
        'content': line.content,
        'date': line.date,
      }),
    );
    return response.statusCode;
  }

 /* Future<int> removeFavoris(int? idClient, Professionnel pro) async{

    var response = await http.post(
      Uri.parse('https://api-colorblast.current.ovh/favoris'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int?>{
        'id_client': idClient,
        'id_pro': pro.id
      }),
    );
    if(response.statusCode==200){
      DataManager().favoris?.removeWhere((element) => element?.id == pro.id);
    }

    return response.statusCode;
  }*/

  Future<List<Line?>?> getLinesByIdMessagerie(int? idMessagerie) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/lines/messagerie/${idMessagerie}');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return lineFromJson(json);
    }
    return null;
  }

}
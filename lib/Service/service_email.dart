import 'dart:convert';

import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/professionnel.dart';
import 'package:http/http.dart' as http;

import '../Model/help.dart';

class ServiceEmail{

  Future<int> forgotPassword(String email, bool workspaceClient) async{

    var client = http.Client();
    var uri;

    if(workspaceClient == true){
      uri = Uri.parse('https://api-colorblast.current.ovh/forgotPasswordClient/${email}');
    }else{
      uri = Uri.parse('https://api-colorblast.current.ovh/forgotPasswordPro/${email}');
    }


    var response = await client.get(uri);
    return response.statusCode;

  }

  Future<int> sendHelpMail(Help help) async {
    final response = await http.post(
      Uri.parse('https://api-colorblast.current.ovh/helpMail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "mail":help.mail,
        "content" : help.content
      }),
    );

    if(response.statusCode==200){
      return response.statusCode;
    }else{
      return response.statusCode;
    }
  }

  Future<void> getCommentProductEmail(String? email, String key) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/commentProduct/${email}/${key}');

    var response = await client.get(uri);

  }

  Future<void> getCommentProEmail(int idClient, int idPro) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/commentPro/${idClient}/${idPro}');

    var response = await client.get(uri);

  }

  Future<void> getMessageForProEmail(String? email, int? idClient) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/messageForPro/${email}/${idClient}');

    var response = await client.get(uri);

  }

  Future<void> getMessageForClientEmail(String? email, int? idPro) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/messageForClient/${email}/${idPro}');

    var response = await client.get(uri);

  }




}
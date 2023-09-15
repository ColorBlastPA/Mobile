import 'dart:convert';

import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/professionnel.dart';
import 'package:http/http.dart' as http;

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

  Future<void> getCommentProductEmail(String email, String key) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/commentProduct/${email}/${key}');

    var response = await client.get(uri);

  }




}
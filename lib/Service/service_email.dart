import 'dart:convert';

import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/professionnel.dart';
import 'package:http/http.dart' as http;

class ServiceEmail{

  Future<int> forgotPassword(String email) async{

    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/forgotPassword/${email}');

    var response = await client.get(uri);
    return response.statusCode;

  }





}
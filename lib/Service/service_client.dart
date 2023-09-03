import 'dart:convert';

import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/professionnel.dart';

import '../Model/client.dart';
import 'package:http/http.dart' as http;

import '../Model/user_pro.dart';

class ServiceClient{
  Future<int> createClient(Client client) async {
    final response = await http.post(
      Uri.parse('https://api-colorblast.current.ovh/client'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "lastname": client.lastname,
        "firstname": client.firstname,
        "mail": client.mail,
        "password": client.password,
        "country": client.country,
        "department": client.department,
        "postal_code": client.postalCode,
        "city": client.city,
        "address": client.address,
      }),
    );

    if(response.statusCode==200){
      return response.statusCode;
    }else{
      return response.statusCode;
    }
  }

  Future<int> login(String mail, String password, bool workspaceClient) async {

    if(workspaceClient == true){
      var response = await http.post(
        Uri.parse('https://api-colorblast.current.ovh/client/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'mail': mail,
          'password': password
        }),
      );
      if(response.statusCode==200){
        var json = response.body;
        DataManager().client =  clientFromJson(json);

      }
      return response.statusCode;
    }else{
      var response = await http.post(
        Uri.parse('https://api-colorblast.current.ovh/professionnel/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'mail': mail,
          'password': password
        }),
      );
      if(response.statusCode==200){
        var json = response.body;
        DataManager().pro =  userProFromJson(json);

      }
      return response.statusCode;
    }




  }

  Future<int> updateClient(Client client) async {
    final response = await http.put(
      Uri.parse('https://api-colorblast.current.ovh/client'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "id": client.id,
        "lastname": client.lastname,
        "firstname": client.firstname,
        "mail": client.mail,
        "password": client.password,
        "country": client.country,
        "department": client.department,
        "postal_code": client.postalCode,
        "city": client.city,
        "address": client.address,
        "avatar": client.avatar,
      }),
    );

    if (response.statusCode == 200) {
      var json = response.body;
      DataManager().client =  clientFromJson(json);
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  Future<int> checkEmail(String mail) async {
    var response = await http.post(
      Uri.parse('https://api-colorblast.current.ovh/client/checkEmail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': mail
      }),
    );
    return response.statusCode;
  }


}
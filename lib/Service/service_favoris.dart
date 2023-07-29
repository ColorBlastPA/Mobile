import 'dart:convert';

import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/professionnel.dart';
import 'package:http/http.dart' as http;

class ServiceFavoris{

  Future<int> createFavoris(int? idClient, Professionnel pro) async{

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
      DataManager().favoris?.add(pro) ;
    }

    return response.statusCode;
  }

  Future<int> removeFavoris(int? idClient, Professionnel pro) async{

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
  }

}
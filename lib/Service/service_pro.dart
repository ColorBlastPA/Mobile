import 'dart:convert';

import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/professionnel.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class ServicePro{

  Future<List<Professionnel?>?> getAllPro() async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/professionnel');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      DataManager().professionnel = professionnelListFromJson(json);
      return DataManager().professionnel;
    }
    return null;
  }

  Future<List<Professionnel?>?> getProFavorisById(int? idClient) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/favoris/${idClient}');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      DataManager().favoris = professionnelListFromJson(json);
      return DataManager().favoris;
    }
    return null;
  }

  Future<http.Response> createPro(Professionnel pro) async {
    final response = await http.post(
      Uri.parse('https://api-colorblast.current.ovh/professionnel'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "lastname": pro.lastname,
        "firstname": pro.firstname,
        "mail": pro.mail,
        "password": pro.password,
        "country": pro.country,
        "department": pro.department,
        "postal_code": pro.postalCode,
        "city": pro.city,
        "company_name": pro.companyName,
        "price": pro.price,
        "phone": pro.phone,
        "note": pro.note,
        "description": pro.description,
        "waiting": pro.waiting,
      }),
    );

    if(response.statusCode==200){
      return response;
    }else{
      return response;
    }
  }


  Future<int> uploadCertificate(int idPro, String filePath) async {
    final uri = Uri.parse('https://api-colorblast.current.ovh/upload-pdf/$idPro');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        filePath, // Chemin du fichier local
        contentType: MediaType('application', 'pdf'),
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }




}
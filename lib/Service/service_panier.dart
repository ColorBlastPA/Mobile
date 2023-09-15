import 'dart:convert';

import 'package:color_blast/Model/panier.dart';
import 'package:http/http.dart' as http;


class ServicePanier{


  Future<List<Panier?>?> getPanierByIdClient(int? idClient) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/paniers/client/${idClient}');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return panierFromJson(json);
    }
    return null;
  }

  Future<void> removePanier(int? idPanier) async {
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/paniers/${idPanier}');

    var response = await client.delete(uri);
    if (response.statusCode == 204) {
      return;
    }
    throw Exception('Failed to remove panier');
  }

  Future<int> createPanier(int? idClient,int? idProduct ) async {
    final response = await http.post(
      Uri.parse('https://api-colorblast.current.ovh/paniers'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "idClient": idClient,
        "idProduct": idProduct
      }),
    );

    if(response.statusCode==200){
      return response.statusCode;
    }else{
      return response.statusCode;
    }
  }

}
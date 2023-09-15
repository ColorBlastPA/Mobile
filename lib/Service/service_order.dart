import 'dart:convert';

import 'package:http/http.dart' as http;



class ServiceOrder{

  Future<int> createOrder(String key, int? idClient, idProduct) async{

    var response = await http.post(
      Uri.parse('https://api-colorblast.current.ovh/orders'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'idKey': key,
        'idClient': idClient,
        'idProduct': idProduct
      }),
    );
    return response.statusCode;
  }




}
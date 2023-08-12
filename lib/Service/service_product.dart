import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/product.dart';
import 'package:color_blast/Model/professionnel.dart';
import 'package:http/http.dart' as http;

class ServiceProduct{

  Future<List<Product?>?> getAllProducts() async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/products');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return productFromJson(json);

    }
    return null;
  }



}
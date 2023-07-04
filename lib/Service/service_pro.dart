import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/professionnel.dart';
import 'package:http/http.dart' as http;

class ServicePro{

  Future<List<Professionnel?>?> getAllPro() async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/professionnel');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      DataManager().professionnel = professionnelFromJson(json);
      return DataManager().professionnel;
    }
    return null;
  }

}
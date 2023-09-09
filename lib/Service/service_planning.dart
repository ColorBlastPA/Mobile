import 'package:color_blast/Model/planning.dart';
import 'package:http/http.dart' as http;

class ServicePlanning{


  Future<List<Planning?>?> getPlanningByIdClient(int? idClient) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/planning/client/${idClient}');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return planningFromJson(json);
    }
    return null;
  }

  Future<List<Planning?>?> getPlanningByIdPro(int? idPro) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/planning/pro/${idPro}');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return planningFromJson(json);
    }
    return null;
  }

}
import 'package:http/http.dart' as http;

import '../Model/comment.dart';

class ServiceComment{

  Future<List<Comment?>?> getAllComments() async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/comments');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return commentFromJson(json);

    }
    return null;
  }

  Future<List<Comment?>?> getCommentsByIdProduct(int idProduct) async{
    var client = http.Client();
    var uri = Uri.parse('https://api-colorblast.current.ovh/comments/Product/${idProduct}');

    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return commentFromJson(json);

    }
    return null;
  }


}
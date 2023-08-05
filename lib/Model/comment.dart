
import 'dart:convert';

List<Comment> commentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
  int id;
  int? idPro;
  int? idProduct;
  String lastname;
  String firstname;
  String content;
  int note;

  Comment({
    required this.id,
    this.idPro,
    this.idProduct,
    required this.lastname,
    required this.firstname,
    required this.content,
    required this.note,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    idPro: json["idPro"],
    idProduct: json["idProduct"],
    lastname: json["lastname"],
    firstname: json["firstname"],
    content: json["content"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idPro": idPro,
    "idProduct": idProduct,
    "lastname": lastname,
    "firstname": firstname,
    "content": content,
    "note": note,
  };
}

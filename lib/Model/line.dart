import 'dart:convert';

List<Line> lineFromJson(String str) => List<Line>.from(json.decode(str).map((x) => Line.fromJson(x)));

String lineToJson(List<Line> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Line {
  int id;
  int idMessagerie;
  String lastname;
  String firstname;
  String content;
  DateTime date;

  Line({
    required this.id,
    required this.idMessagerie,
    required this.lastname,
    required this.firstname,
    required this.content,
    required this.date,
  });

  factory Line.fromJson(Map<String, dynamic> json) => Line(
    id: json["id"],
    idMessagerie: json["idMessagerie"],
    lastname: json["lastname"],
    firstname: json["firstname"],
    content: json["content"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idMessagerie": idMessagerie,
    "lastname": lastname,
    "firstname": firstname,
    "content": content,
    "date": date.toIso8601String(),
  };
}


import 'dart:convert';

Help helpFromJson(String str) => Help.fromJson(json.decode(str));

String helpToJson(Help data) => json.encode(data.toJson());

class Help {
  String mail;
  String content;

  Help({
    required this.mail,
    required this.content,
  });

  factory Help.fromJson(Map<String, dynamic> json) => Help(
    mail: json["mail"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "mail": mail,
    "content": content,
  };
}

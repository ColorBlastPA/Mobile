import 'dart:convert';
List<User> listUserFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.languageIso,
    required this.languageName
  });

  int id;
  String firstname;
  String lastname;
  String email;
  String password;
  String languageIso;
  String languageName;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      email: json["email"],
      password: json["password"],
      languageIso: json['languageIso'],
      languageName: json['languageName']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "password": password,
    "languageIso": languageIso,
    "languageName": languageName
  };
}
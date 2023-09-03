
import 'dart:convert';

Client clientFromJson(String str) => Client.fromJson(json.decode(str));

String clientToJson(Client data) => json.encode(data.toJson());

class Client {
  int id;
  String lastname;
  String firstname;
  String mail;
  String password;
  String country;
  String department;
  String postalCode;
  String city;
  String address;
  String? avatar;

  Client({
    required this.id,
    required this.lastname,
    required this.firstname,
    required this.mail,
    required this.password,
    required this.country,
    required this.department,
    required this.postalCode,
    required this.city,
    required this.address,
    required this.avatar,
  });



  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json["id"],
    lastname: json["lastname"],
    firstname: json["firstname"],
    mail: json["mail"],
    password: json["password"],
    country: json["country"],
    department: json["department"],
    postalCode: json["postal_code"],
    city: json["city"],
    address: json["address"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lastname": lastname,
    "firstname": firstname,
    "mail": mail,
    "password": password,
    "country": country,
    "department": department,
    "postal_code": postalCode,
    "city": city,
    "address": address,
    "avatar": avatar,
  };
}

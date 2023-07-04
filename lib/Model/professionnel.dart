// To parse this JSON data, do
//
//     final professionnel = professionnelFromJson(jsonString);

import 'dart:convert';

List<Professionnel> professionnelFromJson(String str) => List<Professionnel>.from(json.decode(str).map((x) => Professionnel.fromJson(x)));

String professionnelToJson(List<Professionnel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Professionnel {
  int id;
  String lastname;
  String firstname;
  String mail;
  String password;
  String country;
  String department;
  String postalCode;
  String city;
  String companyName;
  double price;
  String phone;
  int note;
  String description;

  Professionnel({
    required this.id,
    required this.lastname,
    required this.firstname,
    required this.mail,
    required this.password,
    required this.country,
    required this.department,
    required this.postalCode,
    required this.city,
    required this.companyName,
    required this.price,
    required this.phone,
    required this.note,
    required this.description,
  });

  factory Professionnel.fromJson(Map<String, dynamic> json) => Professionnel(
    id: json["id"],
    lastname: json["lastname"],
    firstname: json["firstname"],
    mail: json["mail"],
    password: json["password"],
    country: json["country"],
    department: json["department"],
    postalCode: json["postal_code"],
    city: json["city"],
    companyName: json["company_name"],
    price: json["price"],
    phone: json["phone"],
    note: json["note"],
    description: json["description"],
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
    "company_name": companyName,
    "price": price,
    "phone": phone,
    "note": note,
    "description": description,
  };
}

// To parse this JSON data, do
//
//     final messagerie = messagerieFromJson(jsonString);

import 'dart:convert';

List<MessagerieClient> messagerieFromJson(String str) => List<MessagerieClient>.from(json.decode(str).map((x) => MessagerieClient.fromJson(x)));

String messagerieToJson(List<MessagerieClient> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MessagerieClient {
  MessagerieClass messagerie;
  Pro pro;

  MessagerieClient({
    required this.messagerie,
    required this.pro,
  });

  factory MessagerieClient.fromJson(Map<String, dynamic> json) => MessagerieClient(
    messagerie: MessagerieClass.fromJson(json["messagerie"]),
    pro: Pro.fromJson(json["pro"]),
  );

  Map<String, dynamic> toJson() => {
    "messagerie": messagerie.toJson(),
    "pro": pro.toJson(),
  };
}

class MessagerieClass {
  int id;
  int idClient;
  int idPro;
  String lastMessage;
  DateTime dLastMessage;
  DateTime dlastMessage;

  MessagerieClass({
    required this.id,
    required this.idClient,
    required this.idPro,
    required this.lastMessage,
    required this.dLastMessage,
    required this.dlastMessage,
  });

  factory MessagerieClass.fromJson(Map<String, dynamic> json) => MessagerieClass(
    id: json["id"],
    idClient: json["idClient"],
    idPro: json["idPro"],
    lastMessage: json["lastMessage"],
    dLastMessage: DateTime.parse(json["dLastMessage"]),
    dlastMessage: DateTime.parse(json["dlastMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idClient": idClient,
    "idPro": idPro,
    "lastMessage": lastMessage,
    "dLastMessage": dLastMessage.toIso8601String(),
    "dlastMessage": dlastMessage.toIso8601String(),
  };
}

class Pro {
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

  Pro({
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

  factory Pro.fromJson(Map<String, dynamic> json) => Pro(
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

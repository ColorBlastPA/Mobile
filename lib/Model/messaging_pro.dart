
import 'dart:convert';

List<MessagingPro> messagingProFromJson(String str) => List<MessagingPro>.from(json.decode(str).map((x) => MessagingPro.fromJson(x)));

String messagingProToJson(List<MessagingPro> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MessagingPro {
  Messagerie messagerie;
  Client client;

  MessagingPro({
    required this.messagerie,
    required this.client,
  });

  factory MessagingPro.fromJson(Map<String, dynamic> json) => MessagingPro(
    messagerie: Messagerie.fromJson(json["messagerie"]),
    client: Client.fromJson(json["client"]),
  );

  Map<String, dynamic> toJson() => {
    "messagerie": messagerie.toJson(),
    "client": client.toJson(),
  };
}

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
  bool admin;

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
    required this.admin,
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
    admin: json["admin"],
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
    "admin": admin,
  };
}

class Messagerie {
  int id;
  int idClient;
  int idPro;
  String lastMessage;
  DateTime dLastMessage;
  DateTime dlastMessage;

  Messagerie({
    required this.id,
    required this.idClient,
    required this.idPro,
    required this.lastMessage,
    required this.dLastMessage,
    required this.dlastMessage,
  });

  factory Messagerie.fromJson(Map<String, dynamic> json) => Messagerie(
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

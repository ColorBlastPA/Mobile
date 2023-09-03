// To parse this JSON data, do
//
//     final userPro = userProFromJson(jsonString);

import 'dart:convert';

UserPro userProFromJson(String str) => UserPro.fromJson(json.decode(str));

String userProToJson(UserPro data) => json.encode(data.toJson());

class UserPro {
  Pro pro;
  Certificate certificate;

  UserPro({
    required this.pro,
    required this.certificate,
  });

  factory UserPro.fromJson(Map<String, dynamic> json) => UserPro(
    pro: Pro.fromJson(json["pro"]),
    certificate: Certificate.fromJson(json["certificate"]),
  );

  Map<String, dynamic> toJson() => {
    "pro": pro.toJson(),
    "certificate": certificate.toJson(),
  };
}

class Certificate {
  int id;
  String idKey;
  int idPro;
  String filename;
  String url;

  Certificate({
    required this.id,
    required this.idKey,
    required this.idPro,
    required this.filename,
    required this.url,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
    id: json["id"],
    idKey: json["idKey"],
    idPro: json["idPro"],
    filename: json["filename"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idKey": idKey,
    "idPro": idPro,
    "filename": filename,
    "url": url,
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
  int idCertificate;
  String avatar;

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
    required this.idCertificate,
    required this.avatar,
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
    idCertificate: json["idCertificate"],
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
    "company_name": companyName,
    "price": price,
    "phone": phone,
    "note": note,
    "description": description,
    "idCertificate": idCertificate,
    "avatar": avatar,
  };
}

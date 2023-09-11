
import 'dart:convert';

List<Booking> bookingFromJson(String str) => List<Booking>.from(json.decode(str).map((x) => Booking.fromJson(x)));

String bookingToJson(List<Booking> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

BookingClass bookingClassFromJson(String str) => BookingClass.fromJson(json.decode(str));

class Booking {
  BookingClass booking;
  List<_Product> product;
  Quote? quote;

  Booking({
    required this.booking,
    required this.product,
    required this.quote,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    booking: BookingClass.fromJson(json["booking"]),
    product: List<_Product>.from(json["product"].map((x) => _Product.fromJson(x))),
    quote: json["quote"] == null ? null : Quote.fromJson(json["quote"]),
  );

  Map<String, dynamic> toJson() => {
    "booking": booking.toJson(),
    "product": List<dynamic>.from(product.map((x) => x.toJson())),
    "quote": quote?.toJson(),
  };
}

class BookingClass {
  int id;
  int idPro;
  String lastname;
  String firstname;
  String city;
  String address;
  int category;
  double surface;
  DateTime dhDebut;
  DateTime dhFin;
  bool waiting;
  int idClient;

  BookingClass({
    required this.id,
    required this.idPro,
    required this.lastname,
    required this.firstname,
    required this.city,
    required this.address,
    required this.category,
    required this.surface,
    required this.dhDebut,
    required this.dhFin,
    required this.waiting,
    required this.idClient,
  });

  factory BookingClass.fromJson(Map<String, dynamic> json) => BookingClass(
    id: json["id"],
    idPro: json["idPro"],
    lastname: json["lastname"],
    firstname: json["firstname"],
    city: json["city"],
    address: json["address"],
    category: json["category"],
    surface: json["surface"]?.toDouble(),
    dhDebut: DateTime.parse(json["dhDebut"]),
    dhFin: DateTime.parse(json["dhFin"]),
    waiting: json["waiting"],
    idClient: json["idClient"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idPro": idPro,
    "lastname": lastname,
    "firstname": firstname,
    "city": city,
    "address": address,
    "category": category,
    "surface": surface,
    "dhDebut": dhDebut.toIso8601String(),
    "dhFin": dhFin.toIso8601String(),
    "waiting": waiting,
    "idClient": idClient,
  };
}

class _Product {
  int id;
  String name;
  double price;
  String description;
  String? image;
  String category;

  _Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
  });

  factory _Product.fromJson(Map<String, dynamic> json) => _Product(
    id: json["id"],
    name: json["name"],
    price: json["price"]?.toDouble(),
    description: json["description"],
    image: json["image"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "description": description,
    "image": image,
    "category": category,
  };
}

class Quote {
  int id;
  int idBooking;
  String idKey;
  String filename;
  String url;

  Quote({
    required this.id,
    required this.idBooking,
    required this.idKey,
    required this.filename,
    required this.url,
  });

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
    id: json["id"],
    idBooking: json["idBooking"],
    idKey: json["idKey"],
    filename: json["filename"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idBooking": idBooking,
    "idKey": idKey,
    "filename": filename,
    "url": url,
  };
}

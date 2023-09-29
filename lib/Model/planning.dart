
import 'dart:convert';

List<Planning> planningFromJson(String str) => List<Planning>.from(json.decode(str).map((x) => Planning.fromJson(x)));

String planningToJson(List<Planning> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Planning {
  int id;
  int idClient;
  int idPro;
  int idBooking;
  DateTime ddate;
  DateTime fdate;
  bool actif;

  Planning({
    required this.id,
    required this.idClient,
    required this.idPro,
    required this.idBooking,
    required this.ddate,
    required this.fdate,
    required this.actif,
  });

  factory Planning.fromJson(Map<String, dynamic> json) => Planning(
    id: json["id"],
    idClient: json["idClient"],
    idPro: json["idPro"],
    idBooking: json["idBooking"],
    ddate: DateTime.parse(json["ddate"]),
    fdate: DateTime.parse(json["fdate"]),
    actif: json["actif"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idClient": idClient,
    "idPro": idPro,
    "idBooking": idBooking,
    "ddate": ddate.toIso8601String(),
    "fdate": fdate.toIso8601String(),
    "actif": actif,
  };
}

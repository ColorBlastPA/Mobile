
import 'dart:convert';

List<Messagerie> messagerieFromJson(String str) => List<Messagerie>.from(json.decode(str).map((x) => Messagerie.fromJson(x)));

String messagerieToJson(List<Messagerie> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Messagerie {
  int id;
  int idClient;
  int idPro;
  LastMessage lastMessage;
  DateTime? dLastMessage;
  DateTime? dlastMessage;

  Messagerie({
    required this.id,
    required this.idClient,
    required this.idPro,
    required this.lastMessage,
    this.dLastMessage,
    this.dlastMessage,
  });

  factory Messagerie.fromJson(Map<String, dynamic> json) => Messagerie(
    id: json["id"],
    idClient: json["idClient"],
    idPro: json["idPro"],
    lastMessage: lastMessageValues.map[json["lastMessage"]]!,
    dLastMessage: json["dLastMessage"] == null ? null : DateTime.parse(json["dLastMessage"]),
    dlastMessage: json["dlastMessage"] == null ? null : DateTime.parse(json["dlastMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idClient": idClient,
    "idPro": idPro,
    "lastMessage": lastMessageValues.reverse[lastMessage],
    "dLastMessage": dLastMessage?.toIso8601String(),
    "dlastMessage": dlastMessage?.toIso8601String(),
  };
}

enum LastMessage {
  BONJOUR
}

final lastMessageValues = EnumValues({
  "Bonjour !": LastMessage.BONJOUR
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

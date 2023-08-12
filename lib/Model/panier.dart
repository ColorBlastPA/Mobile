
import 'dart:convert';

List<Panier> panierFromJson(String str) => List<Panier>.from(json.decode(str).map((x) => Panier.fromJson(x)));

String panierToJson(List<Panier> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Panier {
  int idPanier;
  Product product;

  Panier({
    required this.idPanier,
    required this.product,
  });

  factory Panier.fromJson(Map<String, dynamic> json) => Panier(
    idPanier: json["idPanier"],
    product: Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "idPanier": idPanier,
    "product": product.toJson(),
  };
}

class Product {
  int id;
  String name;
  double price;
  String description;
  String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    price: json["price"]?.toDouble(),
    description: json["description"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "description": description,
    "category": category,
  };
}

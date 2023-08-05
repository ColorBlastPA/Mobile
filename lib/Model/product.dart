
import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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

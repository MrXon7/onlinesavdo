import 'package:online_savdo/data/models/image_model.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double discount;
  final ImageBB image;
  final String categorie;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.image,
    required this.categorie,
  });

  // JSON dan modelga o'tish
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      discount: json['discount'].toDouble(),
      image: ImageBB.fromJson(json['image']),
      categorie: json['categorie'],
    );
  }

  // Modeldan JSON ga o'tish
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount': discount,
      'image': image.toJson(),
      'categorie': categorie,
    };
  }
}
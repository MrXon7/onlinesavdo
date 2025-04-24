class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double discount;
  final String imageUrl;
  final String categorie;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.imageUrl,
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
      imageUrl: json['imageUrl'],
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
      'imageUrl': imageUrl,
      'categorie': categorie,
    };
  }
}
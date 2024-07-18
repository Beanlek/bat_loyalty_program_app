// import 'dart:convert';
import 'dart:typed_data';

class Product {
  final String id;
  final String name;
  final String brand;
  final Uint8List imageData;
  final int points;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageData,
    required this.points,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      imageData: Uint8List.fromList(List<int>.from(json['image']['data'])),
      points: json['points'],
    );
  }
}

import 'package:flutter/material.dart';

mixin ImageStatusComponents {
  final TextEditingController searchController = TextEditingController();

  List<Widget> sections = [];
  List<List<String>> receipts = [
    [
      'assets/images_examples/receipt-001.jpg',
      'assets/images_examples/receipt-003.jpg',
      'assets/images_examples/receipt-003.jpg',
    ],
    [
      'assets/images_examples/receipt-001.jpg',
      'assets/images_examples/receipt-002.jpg',
      'assets/images_examples/receipt-003.jpg',
      'assets/images_examples/receipt-001.jpg',
      'assets/images_examples/receipt-003.jpg',
    ],
    [
      'assets/images_examples/receipt-001.jpg',
      'assets/images_examples/receipt-002.jpg',
    ],
    [
      'assets/images_examples/receipt-001.jpg',
    ],
  ];

  void setSections() {

  }
}
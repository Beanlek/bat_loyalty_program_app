import 'package:flutter/material.dart';

mixin ImageStatusComponents {
  final TextEditingController searchController = TextEditingController();
  Map<dynamic, dynamic> receipts = {
    "Today": [
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-003.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-003.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
    ],
    "14 July 2024": [
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-002.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-003.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-003.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
    ],
    "13 July 2024": [
      {
        "image": 'assets/images_examples/receipt-002.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
    ],
    "12 July 2024": [
      {
        "image": 'assets/images_examples/receipt-001.jpg',
        "created_at": '2024-07-03 09:11:30.364 +0800'
      },
    ],
  };

  void setSections() {

  }
}
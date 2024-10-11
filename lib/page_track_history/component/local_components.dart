import 'package:flutter/material.dart';

mixin TrackComponents {
  final ScrollController scrollController = ScrollController();

  late Map<String, dynamic> user = {};

  final List<Map<dynamic,dynamic>> dateMap = [
    {
      "data": "Today",
      "filter": false
    },
    {
      "data": "14 July 2024",
      "filter": false
    },
    {
      "data": "13 July 2024",
      "filter": false
    },
    {
      "data": "12 July 2024",
      "filter": false
    },
  ];

   final List<Map<dynamic, dynamic>> products = [
      {
        'title': 'Product 1',
        'imagePath': 'assets/images_examples/headphone.jpeg',
        'code': '123ABC',
        'redeemedDate': '8/10/2024 6:00 AM',
        'points': 1000
      },
      {
        'title': 'Product 2',
        'imagePath': 'assets/images_examples/headphone.jpeg',
        'code': '456DEF',
        'redeemedDate': '7/10/2024 10:00 AM',
        'points': 1500
      },
    ];
}
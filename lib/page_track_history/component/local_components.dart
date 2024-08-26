import 'package:flutter/material.dart';

mixin TrackComponents {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late Map<String, dynamic> user = {};

  Map<dynamic,dynamic> products = {
  "Today": [
    {
      "title": "Headphone",
      "code": "1A2B 3C1A 2B3C 1A2B",
      "imagePath": "assets/images_examples/headphone.jpeg",
      "redeemedDate": "2024-07-13 09:00:00",
      "points": 1200,
      "isDarkMode": false,
    },
  ],
  "13 July 2024": [
    {
      "title": "Headphone",
      "code": "1A2B 3C1A 2B3C 1A2B",
      "imagePath": "assets/images_examples/headphone.jpeg",
      "redeemedDate": "2024-07-13 09:00:00",
      "points": 1200,
      "isDarkMode": false,
    },
    {
      "title": "Smartphone",
      "code": "3D4E 5F3D 4E5F 3D4E",
      "imagePath": "assets/images_examples/headphone.jpeg",
      "redeemedDate": "2024-07-13 10:30:00",
      "points": 2400,
      "isDarkMode": true,
    },
  ],
  "14 July 2024": [
    {
      "title": "Laptop",
      "code": "5G6H 7I5G 6H7I 5G6H",
      "imagePath": "assets/images_examples/headphone.jpeg",
      "redeemedDate": "2024-07-14 11:45:00",
      "points": 4000,
      "isDarkMode": false,
    },
    {
      "title": "Laptop",
      "code": "5G6H 7I5G 6H7I 5G6H",
      "imagePath": "assets/images_examples/headphone.jpeg",
      "redeemedDate": "2024-07-14 11:45:00",
      "points": 4000,
      "isDarkMode": false,
    },
  ],
};

}
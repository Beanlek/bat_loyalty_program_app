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
}
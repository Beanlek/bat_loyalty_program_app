import 'package:flutter/material.dart';

mixin TrackComponents {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late Map<String, dynamic> user = {};
}
import 'package:flutter/material.dart';

mixin HomeComponents {
  final TextEditingController searchController = TextEditingController();

  final FocusNode searchFocusNode = FocusNode();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  int loyaltyPoints = 0;
  String token = '';

  late Map<String, dynamic> user;

}
import 'package:bat_loyalty_program_app/model/product.dart';
import 'package:bat_loyalty_program_app/services/api.dart';
import 'package:flutter/material.dart';

mixin HomeComponents {
  final TextEditingController searchController = TextEditingController();

  final FocusNode searchFocusNode = FocusNode();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  int loyaltyPoints = 0;

  String token = '';

  late Map<String, dynamic> user;
  late Future<List<Product>> futureProduct;
 late Future<List<Product>> _futureProducts;

  final List<Product> _filteredDataList = [];
  final List<Product> _allProducts = [];
  final bool _showFilterOptions = false;
  bool isSearching = false;

  final Api api = Api();
  final Locale locale = const Locale('en');

  late Locale _currentLocale;
  

  
  
}

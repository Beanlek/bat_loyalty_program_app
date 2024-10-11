import 'package:bat_loyalty_program_app/model/product.dart';
import 'package:flutter/material.dart';



mixin ProductComponents {
  final List<Product> _filteredDataList = [];
  final List<Product> _dataList = [];
  final ScrollController _scrollController = ScrollController();

  
  

  final int _currentPage = 0;

  final List<String> imgList = [
      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  ];

}

mixin CounterMixin<T extends StatefulWidget> on State<T> {
  int count = 0; // Initial count value

  // Method to increment the count
  void increment() {
    setState(() {
      count++;
    });
  }

  // Method to decrement the count
  void decrement() {
    setState(() {
      if (count > 0) count--; // Ensures count does not go below 0
    });
  }
}






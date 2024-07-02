import 'package:flutter/material.dart';

class trackingHistoryPage extends StatefulWidget {
  const trackingHistoryPage({super.key});

    static const routeName = '/tracking_history';

  @override
  State<trackingHistoryPage> createState() => _trackingHistoryPageState();
}

class _trackingHistoryPageState extends State<trackingHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: Text("Track History"),
    );
  }
}
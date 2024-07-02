import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/page_homepage/layout/homepage.dart';
import 'package:bat_loyalty_program_app/page_login/layout/login.dart';
import 'package:bat_loyalty_program_app/page_register/layout/register.dart';
import 'package:bat_loyalty_program_app/page_register/layout/register_steps.dart';
import 'package:bat_loyalty_program_app/page_track_history/layout/tracking_history.dart';

class MyArguments {
  const MyArguments(
    this.TOKEN,
    {
      key,

      this.username = 'N/A',
      this.phone = '0123456789',
      this.deviceID = 'flutter123',
      this.appVersion = '0.0.0',
    }
  );

  final String TOKEN;
  
  final String username;
  final String phone;
  final String deviceID;
  final String appVersion;
}

class MyRoutes {
  static Map<String, WidgetBuilder> routes = {
    Homepage.routeName: (context) => Homepage(),
    LoginPage.routeName: (context) => LoginPage(),
    RegisterPage.routeName: (context) => RegisterPage(),
    RegisterStepsPage.routeName: (context) => RegisterStepsPage(),
    trackingHistoryPage.routeName: (context) => trackingHistoryPage(),
  };
}
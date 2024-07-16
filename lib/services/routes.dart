import 'package:bat_loyalty_program_app/dummy.dart';
import 'package:bat_loyalty_program_app/page_homepage/layout/homepage_preview.dart';
import 'package:bat_loyalty_program_app/page_imagestatus/layout/imagestatus.dart';
import 'package:bat_loyalty_program_app/page_profile/layout/profile.dart';
import 'package:flutter/material.dart';

import 'package:bat_loyalty_program_app/page_homepage/layout/homepage.dart';
import 'package:bat_loyalty_program_app/page_login/layout/login.dart';
import 'package:bat_loyalty_program_app/page_register/layout/register.dart';
import 'package:bat_loyalty_program_app/page_register/layout/register_steps.dart';
import 'package:bat_loyalty_program_app/page_track_history/layout/tracking_history.dart';
import 'package:image_picker/image_picker.dart';

class MyArguments {
  const MyArguments(
    this.TOKEN,
    {
      key,

      this.username = 'N/A',
      this.phone = '0123456789',
      this.deviceID = 'flutter123',
      this.appVersion = '0.0.0',

      this.prevPath = '/null',
      this.receiptImage,

      this.user = '{}',
    }
  );

  final String TOKEN;
  
  final String username;
  final String phone;
  final String deviceID;
  final String appVersion;

  final String prevPath;
  final XFile? receiptImage;

  final String user;
}

class MyRoutes {
  static Map<String, WidgetBuilder> routes = {
    Homepage.routeName: (context) => Homepage(),
    HomepagePreview.routeName: (context) => HomepagePreview(),

    LoginPage.routeName: (context) => LoginPage(),
    RegisterPage.routeName: (context) => RegisterPage(),
    RegisterStepsPage.routeName: (context) => RegisterStepsPage(),

    ProfilePage.routeName: (context) => ProfilePage(),

    Dummy.routeName: (context) => Dummy(),
    ImageStatusPage.routeName: (context) => ImageStatusPage(),
    TrackingHistoryPage.routeName: (context) => TrackingHistoryPage(),
  };
}
import 'package:bat_loyalty_program_app/dummy.dart';
import 'package:bat_loyalty_program_app/page_cart/layout/cart.dart';
import 'package:bat_loyalty_program_app/page_homepage/layout/homepage_preview.dart';
import 'package:bat_loyalty_program_app/page_imagestatus/layout/imagestatus.dart';
import 'package:bat_loyalty_program_app/page_manageoutlet/layout/manageoutlet.dart';
import 'package:bat_loyalty_program_app/page_manageoutlet/layout/manageoutlet_add.dart';
import 'package:bat_loyalty_program_app/page_product/layout/product.dart';
import 'package:bat_loyalty_program_app/page_profile/layout/profile.dart';
import 'package:bat_loyalty_program_app/page_profile/layout/profile_edit.dart';
import 'package:bat_loyalty_program_app/page_resetpassword/layout/resetpassword.dart';
import 'package:bat_loyalty_program_app/page_resetpassword/layout/resetpassword_steps.dart';
import 'package:bat_loyalty_program_app/page_settings/layout/settings.dart';
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
      this.outlets = '{}',
      this.urlOriginal,
      this.urlOcr,

      this.currentOutlet = '{}',
      this.productId = '',
      this.imageReceiptId = '',  
    }     
  );

  final String TOKEN;
  
  final String username;
  final String phone;
  final String deviceID;
  final String appVersion;

  final String prevPath;
  final XFile? receiptImage;
  final String? urlOriginal;
  final String? urlOcr;
  final String? imageReceiptId;
  

  final String user;
  final String outlets;
  final String currentOutlet;
  final String productId;

}

class MyRoutes {
  static Map<String, WidgetBuilder> routes = {
    Homepage.routeName: (context) => Homepage(),
    HomepagePreview.routeName: (context) => HomepagePreview(),

    LoginPage.routeName: (context) => LoginPage(),
    RegisterPage.routeName: (context) => RegisterPage(),
    RegisterStepsPage.routeName: (context) => RegisterStepsPage(),
    ResetPasswordPage.routeName: (context) => ResetPasswordPage(),
    ResetPasswordStepsPage.routeName: (context) => ResetPasswordStepsPage(),

    ProfilePage.routeName: (context) => ProfilePage(),
    ProfileEditPage.routeName: (context) => ProfileEditPage(),

    ProductPage.routeName: (context) => ProductPage(),
    CartPage.routeName: (context) => CartPage(),

    ManageOutletPage.routeName: (context) => ManageOutletPage(),
    ManageOutletAddPage.routeName: (context) => ManageOutletAddPage(),

    SettingsPage.routeName: (context) => SettingsPage(),

    Dummy.routeName: (context) => Dummy(),
    ImageStatusPage.routeName: (context) => ImageStatusPage(),
    TrackingHistoryPage.routeName: (context) => TrackingHistoryPage(),
  };
}
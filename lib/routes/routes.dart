import 'package:flutter/material.dart';
import 'package:nfc_wallet/payment_screens/payment_screen.dart';
import 'package:nfc_wallet/screens/home/home/home.dart';

class PageRoutes {
  static const String homePage = 'home_page';
  static const String navigation = 'navigation_home';

  Map<String, WidgetBuilder> routes() {
    return {
      homePage: (context) => Home(),
      navigation: (context) => PaymentScreen(),
    };
  }
}

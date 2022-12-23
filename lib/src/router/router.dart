import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appStartPage.dart';

class GeneratedRouter {
  static Route? router(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => StartPage());
    }
  }
}

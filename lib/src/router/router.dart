import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/RegisterProcesses/appRegisterStepOnePage.dart';
import 'package:gamebrige/src/screens/RegisterProcesses/appRegisterStepTwoPage.dart';
import 'package:gamebrige/src/screens/appBottomBarPage.dart';
import 'package:gamebrige/src/screens/appLandingPage.dart';
import 'package:gamebrige/src/screens/appLoginPage.dart';

import '../screens/404/dortyuzdort.dart';

class GeneratedRouter {
  static Route? router(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        //return MaterialPageRoute(builder: (context) => const StartPage());
        return MaterialPageRoute(
            builder: (context) => const RegisterStepTwoPage());
      case '/Tab':
        return MaterialPageRoute(builder: (context) => const BottomBar());
      case '/Landing':
        return MaterialPageRoute(builder: (context) => const LandingPage());
      case '/Login':
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case '/RegisterStep1':
        return MaterialPageRoute(
            builder: (context) => const RegisterStepOnePage());
      case '/RegisterStep2':
        return MaterialPageRoute(
            builder: (context) => const RegisterStepTwoPage());
      case '/404':
        return MaterialPageRoute(
            builder: (context) => const DortyuzdortPagexd());
    }
    return null;
  }
}

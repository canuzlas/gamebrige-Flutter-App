import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/RegisterProcesses/appRegisterStepOnePage.dart';
import 'package:gamebrige/src/screens/RegisterProcesses/appRegisterStepTwoPage.dart';
import 'package:gamebrige/src/screens/appMain/appLandingPage.dart';
import 'package:gamebrige/src/screens/appMain/appLoginPage.dart';
import 'package:gamebrige/src/screens/appMain/appOtherProfilePage.dart';
import 'package:gamebrige/src/screens/appMain/appReadSelectedBlogPage.dart';
import 'package:gamebrige/src/screens/appMain/appShareBlogPage.dart';
import 'package:gamebrige/src/screens/appMain/appUpdateBlogPage.dart';
import 'package:gamebrige/src/screens/appMain/bottomBar/view/appBottomBarPage.dart';
import 'package:gamebrige/src/screens/appMain/startPage/view/appStartPage.dart';
import 'package:gamebrige/src/screens/messages/appAllMessagesPage.dart';
import 'package:gamebrige/src/screens/messages/appMessagingPage.dart';
import 'package:gamebrige/src/screens/messages/appSendMessagePage.dart';

import '../screens/404/dortyuzdort.dart';
import '../screens/RegisterProcesses/appRegisterStepFourPage.dart';
import '../screens/RegisterProcesses/appRegisterStepThreePage.dart';

class GeneratedRouter {
  static Route? router(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const StartPage());
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
      case '/RegisterStep3':
        return MaterialPageRoute(
            builder: (context) => const RegisterStepThreePage());
      case '/RegisterStep4':
        return MaterialPageRoute(
            builder: (context) => const RegisterStepFourPage());
      case '/404':
        return MaterialPageRoute(
            builder: (context) => const DortyuzdortPagexd());
      case '/ReadSelectedBlog':
        return MaterialPageRoute(
            builder: (context) =>
                ReadSelectedBlogPage(blogId: settings.arguments));
      case '/OtherProfile':
        return MaterialPageRoute(
            builder: (context) =>
                OtherProfilePage(person_id: settings.arguments));
      case '/BlogShare':
        return MaterialPageRoute(builder: (context) => const BlogSharePage());
      case '/UpdateBlog':
        return MaterialPageRoute(
            builder: (context) => BlogUpdatePage(blog: settings.arguments));
      case '/AllMessages':
        return MaterialPageRoute(builder: (context) => const AllMessagesPage());
      case '/SendMessage':
        return MaterialPageRoute(builder: (context) => const SendMessagePage());
      case '/MessagingPage':
        return MaterialPageRoute(
            builder: (context) =>
                MessagingPage(messagingUser: settings.arguments));
    }
    return null;
  }
}

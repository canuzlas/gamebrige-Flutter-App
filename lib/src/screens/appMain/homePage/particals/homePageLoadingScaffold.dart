import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appMain/homePage/controller/homePageController.dart';
import 'package:gamebrige/src/screens/appMain/homePage/particals/homePageHeader.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'homePageBodyTopFont.dart';

class HomePageLoadingScaffold extends StatefulWidget {
  HomePageLoadingScaffold({Key? key}) : super(key: key);

  @override
  State<HomePageLoadingScaffold> createState() =>
      _HomePageLoadingScaffoldState();
}

class _HomePageLoadingScaffoldState extends State<HomePageLoadingScaffold> {
  HomePageController homePageController = HomePageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
        body: Column(
          children: [
            //header
            HomePageHeader(),
            //top font
            HomePageTopFont(),
            Center(
              child: Container(
                height: 300,
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 100,
                ),
              ),
            )
          ],
        ));
  }
}

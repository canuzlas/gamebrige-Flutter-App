import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'myProfilePageAppBar.dart';

class MyProfilePageLoadingScaffold extends StatefulWidget {
  final user;
  const MyProfilePageLoadingScaffold({Key? key, this.user}) : super(key: key);

  @override
  State<MyProfilePageLoadingScaffold> createState() =>
      _MyProfilePageLoadingScaffoldState();
}

class _MyProfilePageLoadingScaffoldState
    extends State<MyProfilePageLoadingScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyProfilePageAppBar(),
        backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
        body: Column(
          children: [
            // blogs
            Center(
              child: Center(
                child: SizedBox(
                  height: 300,
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

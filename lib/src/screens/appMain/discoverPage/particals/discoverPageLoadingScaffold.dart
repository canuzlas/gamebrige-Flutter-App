import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'discoverPageHeader.dart';
import 'discoverPageTopFont.dart';

class DiscoverPageLoadingPage extends StatelessWidget {
  const DiscoverPageLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
        body: Column(
          children: [
            //header
            const DiscoverPageHeader(),
            //top font
            const DiscoverPageTopFont(),
            Center(
              child: SizedBox(
                height: 300,
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 100,
                ),
              ),
            )
          ],
        ));
    ;
  }
}

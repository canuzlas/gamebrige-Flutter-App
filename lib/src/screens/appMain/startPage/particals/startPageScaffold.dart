import 'package:flutter/material.dart';

class StartPageScaffold extends StatelessWidget {
  const StartPageScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        //bg image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/startpage-bg.jpeg"),
                fit: BoxFit.cover),
          ),
        ),
        //font
        Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 100),
          child: const Text("GAMEBRIGE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 45,
                fontWeight: FontWeight.w900,
              )),
        ),
      ]),
    );
  }
}

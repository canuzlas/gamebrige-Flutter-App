import 'dart:io';

import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //gamebrige yazı
          Padding(
            padding: EdgeInsets.only(bottom: 100),
            child: Center(
              child: Text("GAMEBRIGE",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                  )),
            ),
          ),
          //login buttons
          Platform.isIOS ? Text("ios") : Text("and")
        ],
      ),
    );
  }
}

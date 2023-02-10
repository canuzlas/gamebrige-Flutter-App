import 'package:flutter/material.dart';

class HomePageTopFont extends StatelessWidget {
  const HomePageTopFont({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text("Takip Ettiğin Kişilerin Gönderileri"),
    );
  }
}

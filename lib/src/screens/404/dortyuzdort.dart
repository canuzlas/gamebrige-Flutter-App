import 'package:flutter/material.dart';

class DortyuzdortPagexd extends StatelessWidget {
  const DortyuzdortPagexd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(60),
              child: Image.asset("assets/images/404.png"),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 100),
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              "İnternetini kontrol et, eğer internetinde sorun yoksa lütfen uygulamayı tekrar başlat.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}

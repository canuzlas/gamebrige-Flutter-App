import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);
  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg-landing.jpeg"),
                    fit: BoxFit.cover),
              ),
            ),
            const Center(
              child: Text("GAMEBRIGE",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                  )),
            ),
            Container(
              margin: EdgeInsets.only(top: 150),
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: const Center(
                  child: Text(
                      '"Oyunlarla ilgili anlatmak istedğin bir şeyler mi var?"',
                      style: TextStyle(color: Colors.white60, fontSize: 15)),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 30),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/Login");
                },
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.transparent),
                    padding: MaterialStatePropertyAll(EdgeInsets.all(11.0)),
                    elevation: MaterialStatePropertyAll(10.0),
                    side: MaterialStatePropertyAll(
                        BorderSide(width: 1.0, color: Colors.white))),
                child: const Text(
                  "Hadi Başlayalım",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

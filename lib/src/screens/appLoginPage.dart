import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //bg image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/login-bg.jpeg"),
                  fit: BoxFit.cover),
            ),
          ),
          //gamebrige yazı
          const Padding(
            padding: EdgeInsets.only(bottom: 200),
            child: Center(
              child: Text("GAMEBRIGE",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                  )),
            ),
          ),
          //login forms
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
                child: TextFormField(
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white60),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white60),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: 'Kullanıcı adınızı girin',
              ),
              style: TextStyle(color: Colors.white60),
            )),
          ),
          Container(
            margin: const EdgeInsets.only(top: 120),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                  child: TextFormField(
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white60),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white60),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: 'Şifrenizi girin',
                ),
                style: TextStyle(color: Colors.white60),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 250),
            child: Center(
              child: OutlinedButton(
                onPressed: () {},
                child: Text(
                  "Giriş Yap",
                  style: TextStyle(color: Colors.white),
                ),
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.transparent),
                    padding: MaterialStatePropertyAll(EdgeInsets.all(11.0)),
                    elevation: MaterialStatePropertyAll(10.0),
                    side: MaterialStatePropertyAll(
                        BorderSide(width: 1.0, color: Colors.white))),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Hesabın yok mu?  ",
                  style: TextStyle(color: Colors.white70),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/RegisterStep1");
                  },
                  child: const Text(
                    "Kayıt Ol",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

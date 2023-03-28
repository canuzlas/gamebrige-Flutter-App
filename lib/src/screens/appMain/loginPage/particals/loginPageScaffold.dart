import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../controller/loginPageController.dart';

class LoginPageScaffold extends StatefulWidget {
  const LoginPageScaffold({Key? key}) : super(key: key);

  @override
  State<LoginPageScaffold> createState() => _LoginPageScaffoldState();
}

class _LoginPageScaffoldState extends State<LoginPageScaffold> {
  LoginPageController loginPageController = LoginPageController();
  String usernameormail = "";
  String pass = "";

  _googleSignIn() async {
    var res = await loginPageController.signInWithGoogle();
    if (res != false) {
      var user = {
        "username": res.displayName,
        "email": res.email,
        "fbuid": FirebaseAuth.instance.currentUser?.uid
      };
      var data =
          await loginPageController.loginOrRegisterWithGoogle(context, user);
      if (data["login"]) {
        Fluttertoast.showToast(
            msg: "Giriş Yapıldı.!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushNamed(context, '/Tab');
      } else {
        Fluttertoast.showToast(
            msg: "Kayıt Yapıldı.!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushNamed(context, '/Tab');
      }
    } else {
      Fluttertoast.showToast(
          msg: "Giriş iptal edildi.!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.transparent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

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
            padding: EdgeInsets.only(bottom: 450),
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
          Container(
            margin: const EdgeInsets.only(bottom: 200),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                  child: TextFormField(
                onChanged: (str) {
                  setState(() {
                    usernameormail = str;
                  });
                },
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white60),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white60),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: 'Kullanıcı adı veya e-postanızı girin',
                ),
                style: TextStyle(color: Colors.white60),
              )),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 80),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                  child: TextFormField(
                onChanged: (str) {
                  setState(() {
                    pass = str;
                  });
                },
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
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 0, top: 20, right: 20),
            child: GestureDetector(
              onTap: () {
                loginPageController.showMailPopup(context);
              },
              child: const Text(
                "Şifremi unuttum",
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 100),
            child: Center(
              child: OutlinedButton(
                onPressed: () =>
                    loginPageController.login(context, usernameormail, pass),
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.transparent),
                    padding: MaterialStatePropertyAll(EdgeInsets.all(11.0)),
                    elevation: MaterialStatePropertyAll(10.0),
                    side: MaterialStatePropertyAll(
                        BorderSide(width: 1.0, color: Colors.white))),
                child: const Text(
                  "Giriş Yap",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _googleSignIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 200),
                    height: 40,
                    child: SignInButton(
                      Buttons.Google,
                      text: "Google ile giriş yap",
                      onPressed: () {
                        _googleSignIn();
                      },
                    ),
                  ),
                )
              ],
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

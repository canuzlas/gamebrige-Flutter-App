import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'appStartPage.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  String usernameormail = "";
  String pass = "";
  late SharedPreferences prefs;

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    //print(prefs.getString("user"));
  }

  login() async {
    if (usernameormail.isEmpty || pass.isEmpty) {
      Fluttertoast.showToast(
          msg: "Kullanıcı adı ve şifre boş bırakılamaz.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.transparent,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      var url = "${dotenv.env['API_URL']!}api/login";
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'appId': dotenv.env['APP_ID'],
            'usernameormail': usernameormail,
            'pass': pass
          },
        ),
      );
      var decodedResponse = jsonDecode(response.body);
      if (decodedResponse['appId'] != null) {
        Navigator.pushNamed(context, '/404');
      } else {
        if (decodedResponse['error'] != null) {
          Fluttertoast.showToast(
              msg: "Sistemsel Hata.!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          if (decodedResponse['login'] == false) {
            Fluttertoast.showToast(
                msg: "Lütfen bilgilerini kontrol et!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.transparent,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print(decodedResponse);
            await prefs.setString("user", jsonEncode(decodedResponse["user"]));
            suser = Provider((ref) => jsonEncode(decodedResponse["user"]));
            //ref.read(suser.state).state = jsonEncode(decodedResponse["user"]);
            try {
              UserCredential userCredential =
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: decodedResponse["user"]["mail"],
                password: pass,
              );
              await prefs.setString(
                "fbuser",
                jsonEncode(userCredential.user?.uid),
              );
            } on FirebaseAuthException catch (e) {
            } catch (e) {
              Fluttertoast.showToast(
                  msg: "Firebase Hata .! Lütfen Giriş Yap.!",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.transparent,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            Fluttertoast.showToast(
                msg: "Giriş Başarılı !",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.transparent,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pushNamed(context, '/Tab');
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
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
          Container(
            margin: const EdgeInsets.only(top: 120),
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
            margin: EdgeInsets.only(top: 250),
            child: Center(
              child: OutlinedButton(
                onPressed: login,
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

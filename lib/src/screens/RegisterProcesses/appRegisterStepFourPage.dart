import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../appMain/appStartPage.dart';

class RegisterStepFourPage extends StatefulWidget {
  const RegisterStepFourPage({Key? key}) : super(key: key);

  @override
  State<RegisterStepFourPage> createState() => _RegisterStepFourPageState();
}

class _RegisterStepFourPageState extends State<RegisterStepFourPage> {
  bool passwordVisible = true;
  late String pass = "";
  late String repass = "";
  late bool possibleCont;

  late SharedPreferences prefs;

  Future<bool> _onWillPop() async {
    return false;
  }

  void initAsyncStorage() async {
    prefs = await SharedPreferences.getInstance();
    print(prefs.getKeys());
    print(prefs.getString("willregmail"));
    print(prefs.getString("willregusername"));
    print(prefs.getString("token"));
  }

  String? validatePassword(String? value) {
    String pattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,16}$";
    final regex = RegExp(pattern);
    if (value!.isNotEmpty && !regex.hasMatch(value)) {
      return 'Şifreniz minimum 8 maximum 16 karakter olabilir\nEn az bir harf ve bir rakam içermelidir';
    } else {
      value!.isEmpty ? possibleCont = false : possibleCont = true;
      return null;
    }
  }

  registerToUser(BuildContext context) async {
    if (pass != repass) {
      Fluttertoast.showToast(
          msg: "Şifreler aynı değil.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.transparent,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: prefs.getString("willregmail").toString(),
                password: pass.toString());

        var url = "${dotenv.env['API_URL']!}api/register";
        var response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'appId': dotenv.env['APP_ID'],
              'username': prefs.getString("willregusername"),
              'mail': prefs.getString("willregmail"),
              'pass': pass.toString(),
              'fbuid': userCredential.user?.uid
            },
          ),
        );
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['appId'] != null) {
          Navigator.pushNamed(context, '/404');
        } else {
          if (decodedResponse['error'] != null) {
            await FirebaseAuth.instance.currentUser?.delete();
            Fluttertoast.showToast(
                msg: "Sistemsel Hata.!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.transparent,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            if (decodedResponse['register'] == false) {
              Fluttertoast.showToast(
                  msg: "Sistemsel Hata.!",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.transparent,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              prefs.remove("deneme");
              prefs.remove("willregmail");
              prefs.remove("willregusername");
              prefs.remove("otpcode");
              prefs.setString("user", jsonEncode(decodedResponse["user"]));
              suser = Provider((ref) => jsonEncode(decodedResponse["user"]));
              Fluttertoast.showToast(
                  msg: "Kayıt Olma Başarılı!",
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
      } on FirebaseAuthException catch (e) {
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Firebase Hata.! Lüten uygulamayı tekrar çalıştır.!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initAsyncStorage();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            //bg image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/register.jpeg"),
                    fit: BoxFit.cover),
              ),
            ),
            //top text
            Container(
              margin: EdgeInsets.only(bottom: 200),
              child: const Center(
                child: Text(
                  "Güvenli bir şifre oluştur.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.white60),
                ),
              ),
            ),
            //input for pass
            Container(
              margin: EdgeInsets.only(top: 10),
              //margin: const EdgeInsets.only(top: 120),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      obscureText: passwordVisible,
                      validator: validatePassword,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Şifre',
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white60,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (txt) {
                        setState(() {
                          pass = txt;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            //input for repass
            Container(
              margin: EdgeInsets.only(top: 170),
              //margin: const EdgeInsets.only(top: 120),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    child: TextFormField(
                      obscureText: passwordVisible,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Şifre tekrarı',
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (txt) {
                        setState(() {
                          repass = txt;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            // continue button
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 50),
              child: OutlinedButton(
                onPressed: () {
                  possibleCont == true
                      ? registerToUser(context)
                      : pass.length == 0
                          ? Fluttertoast.showToast(
                              msg: "Boş bırakılamaz.",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.transparent,
                              textColor: Colors.white,
                              fontSize: 16.0)
                          : null;
                },
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.transparent),
                    padding: MaterialStatePropertyAll(EdgeInsets.all(11.0)),
                    elevation: MaterialStatePropertyAll(10.0),
                    side: MaterialStatePropertyAll(
                        BorderSide(width: 1.0, color: Colors.white))),
                child: const Text(
                  "Devam Et",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

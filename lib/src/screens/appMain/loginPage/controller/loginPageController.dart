import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamebrige/src/sm/sm_with_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../smtp/smtp.dart';

class LoginPageController {
  late String mail;
  Future<void> showMailPopup(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
          title: const Center(child: Text('Mail adresini yaz')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Center(
                      child: TextFormField(
                    onChanged: (str) {
                      mail = str;
                    },
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'mail adresin',
                    ),
                    style: TextStyle(color: Colors.black),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('gönder'),
              onPressed: () {
                sendChangePasswordOTPCode(mail, context);
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/ChangePassOTP');
              },
            ),
          ],
        );
      },
    );
  }

  sendChangePasswordOTPCode(mail, context) async {
    await getSharedPreferences();
    num code = 100000 + Random().nextInt(900000);
    await SMTPASS(code, mail, context);
    prefs.setInt("changepassotp", code);
    prefs.setString("changepassmail", mail);
  }

  late var prefs;

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  login(context, usernameormail, pass) async {
    await getSharedPreferences();
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
            //print(decodedResponse["user"]);
            await prefs.setString("user", jsonEncode(decodedResponse["user"]));
            suser = Provider((ref) => jsonEncode(decodedResponse["user"]));

            //ref.read(suser.state).state = jsonEncode(decodedResponse["user"]);
            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: decodedResponse["user"]["mail"],
                password: pass,
              );
            } on FirebaseAuthException catch (e) {
              Fluttertoast.showToast(
                  msg: "Firebase Hata .! Lütfen Tekrar Giriş Yap.!",
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

  signInWithGoogle() async {
    // Trigger the authentication flow
    await GoogleSignIn().signOut();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      return googleUser;
    } else {
      return false;
    }
  }

  loginOrRegisterWithGoogle(context, user) async {
    getSharedPreferences();
    var url = "${dotenv.env['API_URL']!}api/loginwithgoogle";
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          'appId': dotenv.env['APP_ID'],
          'user': user,
        },
      ),
    );
    var decodedResponse = jsonDecode(response.body);
    if (decodedResponse['appId'] != null) {
      Navigator.pushNamed(context, '/404');
      return false;
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
        return false;
      } else {
        await prefs.setString("user", jsonEncode(decodedResponse["user"]));
        suser = Provider((ref) => jsonEncode(decodedResponse["user"]));
        return decodedResponse;
      }
    }
  }
}

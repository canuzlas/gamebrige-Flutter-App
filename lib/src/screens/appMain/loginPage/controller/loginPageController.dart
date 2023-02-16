import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamebrige/src/sm/sm_with_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageController {
  late var prefs;

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  login(context, usernameormail, pass) async {
    getSharedPreferences();
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
            } on FirebaseAuthException catch (e) {
            } catch (e) {
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

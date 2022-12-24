import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

late final deneme;

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late Map token = {};
  late SharedPreferences prefs;

  void setTimeout(callback, time) {
    Duration timeDelay = Duration(milliseconds: time);
    Timer(timeDelay, callback);
  }

  @override
  void initState() {
    super.initState();
    void getToken() async {
      // async store referans oluşturuyoruz
      prefs = await SharedPreferences.getInstance();
      //apiden token alıyoruz
      var response = await http.get(Uri.parse("http://127.0.0.1:3000/api"));
      token = jsonDecode(response.body);
      //gelen json datası decode edilip storeye kaydediliuor.
      prefs.setString("token", token["token"].toString());

      deneme = Provider((ref) => token["token"].toString());
    }

    getToken();
    setTimeout(() => {Navigator.pushNamed(context, '/Tab')}, 2000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/images/logo.png")),
    );
  }
}

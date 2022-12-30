import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      var url = "${dotenv.env['API_URL']!}api";
      // async store referans oluşturuyoruz
      prefs = await SharedPreferences.getInstance();
      //apiden token alıyoruz
      var response = await http.get(Uri.parse(url));
      token = jsonDecode(response.body);
      //gelen json datası decode edilip storeye kaydediliuor.
      prefs.setString("token", token["token"].toString());
      print(token["token"]);
      deneme = Provider((ref) => token["token"].toString());
    }

    getToken();
    setTimeout(() => {Navigator.pushNamed(context, '/Landing')}, 2000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/startpage-bg.jpeg"),
                fit: BoxFit.cover),
          ),
        ),
        const Center(
          child: Text("GAMEBRIGE",
              style: TextStyle(
                color: Colors.black,
                fontSize: 45,
                fontWeight: FontWeight.w900,
              )),
        ),
      ]),
    );
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//statment manage exmp
late final stoken;
late var suser;

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  FirebaseDatabase database = FirebaseDatabase.instance;

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
      var url = "${dotenv.env['API_URL']!}api/${dotenv.env['APP_ID']!}";
      // async store referans oluşturuyoruz
      prefs = await SharedPreferences.getInstance();
      //apiden token alıyoruz
      var response = await http.get(Uri.parse(url));
      print(response.body);
      var u_id = jsonDecode(prefs.getString("fbuser").toString());
      print(u_id);

      token = jsonDecode(response.body);
      //token geldi mi?
      if (token["token"] != null) {
        stoken = Provider((ref) => token["token"].toString());
        //gelen json datası decode edilip storeye kaydediliuor.
        prefs.setString("token", token["token"].toString());
        //user kontrol ediliyor
        if (prefs.getString("user") != null) {
          suser = Provider((ref) => prefs.getString("user"));
          setTimeout(() => {Navigator.pushNamed(context, '/Tab')}, 2000);
        } else {
          setTimeout(() => {Navigator.pushNamed(context, '/Landing')}, 2000);
        }
      } else {
        //token gelmediyse hatayı bildir
        setTimeout(() => {Navigator.pushNamed(context, '/404')}, 2000);
      }
    }

    try {
      getToken();
    } on Exception catch (exception) {
      setTimeout(() => {Navigator.pushNamed(context, '/404')}, 2000);
    } catch (error) {
      setTimeout(() => {Navigator.pushNamed(context, '/404')}, 2000);
    }
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
        Container(
          padding: EdgeInsets.only(bottom: 200),
          child: const Center(
            child: Text("GAMEBRIGE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.w900,
                )),
          ),
        ),
      ]),
    );
  }
}

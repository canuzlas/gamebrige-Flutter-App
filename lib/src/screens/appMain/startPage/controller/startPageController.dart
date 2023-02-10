import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamebrige/src/sm/sm_with_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPageController {
  FirebaseDatabase database = FirebaseDatabase.instance;

  late Map token = {};
  late SharedPreferences prefs;

  void setTimeout(callback, time) {
    Duration timeDelay = Duration(milliseconds: time);
    Timer(timeDelay, callback);
  }

  getPermissions() async {
    var status = await Permission.notification.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      Fluttertoast.showToast(
          msg: "Lütfen Bildirimleri Etkinleştirin!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.transparent,
          textColor: Colors.white,
          fontSize: 16.0);
      await Permission.notification.request();
    }
  }

  getToken(context) async {
    var url = "${dotenv.env['API_URL']!}api/${dotenv.env['APP_ID']!}";
    // async store referans oluşturuyoruz
    prefs = await SharedPreferences.getInstance();
    //apiden token alıyoruz
    var response = await http.get(Uri.parse(url));

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
}

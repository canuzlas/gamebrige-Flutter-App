import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageController {
  FirebaseDatabase database = FirebaseDatabase.instance;

  late SharedPreferences prefs;
  late List<dynamic> blogs = [];

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  getFollowedsBlogs(token, user) async {
    var url = "${dotenv.env['API_URL']!}api/getfollowedsblogs";
    //apiden blogları alıyoruz
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appId': dotenv.env['APP_ID'],
          'token': token,
          "JWT_SECRET": dotenv.env['JWT_SECRET'],
          'user': user,
        }));
    var decodedResponse = jsonDecode(response.body);
    if (decodedResponse['appId'] != null) {
      Fluttertoast.showToast(
          msg: "Uygulamayı tekrar başlatın.!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.transparent,
          textColor: Colors.white,
          fontSize: 16.0);
      return [];
    } else {
      if (decodedResponse['tokenError'] != null) {
        Fluttertoast.showToast(
            msg:
                "Oturum süreniz dolmuştur lütfen uygulamayı yeniden başlatın.!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            fontSize: 16.0);
        return [];
      } else {
        blogs = decodedResponse['blogs'];
        return blogs;
      }
    }
  }

  getPermissions() async {
    var status = await Permission.notification.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      await Permission.notification.request();
      Fluttertoast.showToast(
          msg: "Lütfen Bildirimleri Etkinleştirin!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.transparent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  createMessageListenerForNotification(user) async {
    var decodedUser = jsonDecode(user);
    database.databaseURL =
        "https://com-uzlas-gamebrige-default-rtdb.firebaseio.com/";
    database
        .ref('Messages/${decodedUser["fbuid"]}')
        .onChildChanged
        .listen((event) async {
      var key = event.snapshot.key;
      var lastMessage = await database
          .ref('Messages/${decodedUser["fbuid"]}/${key}')
          .limitToLast(1)
          .get();
      var res = lastMessage.value as Map;
      if (res.values.last["sender_fbuid"] == decodedUser["fbuid"]) {
        return;
      } else {
        var status = await Permission.notification.status;
        if (status.isDenied || status.isPermanentlyDenied) {
          Fluttertoast.showToast(
              msg:
                  "Mesaj Bildirimleri İçin Lütfen Bildirimleri Etkinleştirin.!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 10,
                  channelKey: 'basic_channel',
                  title: 'Yeni Bir Mesajın Var',
                  body:
                      '${res.values.last["sender_username"]} : ${res.values.last["message"]}',
                  actionType: ActionType.Default));
        }
      }
    });
  }
}

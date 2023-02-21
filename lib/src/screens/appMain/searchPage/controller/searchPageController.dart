import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamebrige/src/sm/sm_with_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchPageController {
  var users = [];
  var bestusers = [];
  late SharedPreferences prefs;

  late var token;
  late var user;

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  searchUser(token, user, txt) async {
    var refuser = jsonDecode(user);
    var url = "${dotenv.env['API_URL']!}api/searchperson";
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          'appId': dotenv.env['APP_ID'],
          'token': token,
          'userid': refuser["_id"],
          "word": txt
        },
      ),
    );
    var decodedResponse = jsonDecode(response.body);
    if (decodedResponse['appId'] != null) {
      Fluttertoast.showToast(
          msg: "Uygulamayı yeniden başlatın.!",
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
        if (decodedResponse["error"] == true) {
          Fluttertoast.showToast(
              msg: "Hata oluştu !",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              fontSize: 16.0);
          return [];
        } else {
          users = decodedResponse['searchedUsers'];
          return users;
        }
      }
    }
  }

  getBestUsers(token, user) async {
    var url = "${dotenv.env['API_URL']!}api/getbestusers";
    //apiden blogları alıyoruz
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          'appId': dotenv.env['APP_ID'],
          'token': token,
          'user': user,
        },
      ),
    );
    var decodedResponse = jsonDecode(response.body);
    //print(decodedResponse);
    if (decodedResponse['appId'] != null) {
      Fluttertoast.showToast(
          msg: "Uygulamayı yeniden başlatın.!",
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
        if (decodedResponse["error"] == true) {
          Fluttertoast.showToast(
              msg: "Hata oluştu !",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              fontSize: 16.0);
          return [];
        } else {
          bestusers = decodedResponse['users'];
          return bestusers;
        }
      }
    }
  }

  followPerson(context, token, user, willfollowid) async {
    await getSharedPreferences();
    var url = "${dotenv.env['API_URL']!}api/followperson";
    //apiden blogları alıyoruz
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          'appId': dotenv.env['APP_ID'],
          'token': token,
          'user': user,
          'willfollowpersonid': willfollowid,
        },
      ),
    );
    var decodedResponse = jsonDecode(response.body);
    print(decodedResponse);
    if (decodedResponse['appId'] != null) {
      Navigator.pushNamed(context, '/404');
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
      } else {
        if (decodedResponse["error"] == "followed") {
          Fluttertoast.showToast(
              msg: "Zaten takip ediyorsun!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          if (decodedResponse["error"] == true) {
            Fluttertoast.showToast(
                msg: "Hata Oluştu!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.transparent,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print(jsonEncode(decodedResponse["user"]));
            suser = Provider((ref) => jsonEncode(decodedResponse["user"]));
            prefs.setString("user", jsonEncode(decodedResponse["user"]));
            Fluttertoast.showToast(
                msg: "Takip edildi!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.transparent,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      }
    }
  }
}

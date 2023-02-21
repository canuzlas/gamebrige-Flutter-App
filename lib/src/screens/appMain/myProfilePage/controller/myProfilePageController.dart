import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyProfilePageController {
  late SharedPreferences prefs;

  var blogs = [];

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  getMyBlogs(token, user) async {
    var url = "${dotenv.env['API_URL']!}api/getmyblogs";
    //apiden blogları alıyoruz
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appId': dotenv.env['APP_ID'],
          'token': token,
          '_id': user["_id"],
        }));
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
        blogs = decodedResponse['blogs'];
        return blogs;
      }
    }
  }

  deleteBlog(context, id, blog, token) async {
    var url = "${dotenv.env['API_URL']!}api/deleteblog";
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
          'blog_id': id,
        },
      ),
    );
    var decodedResponse = jsonDecode(response.body);
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
        if (decodedResponse['error'] == false) {
          Fluttertoast.showToast(
              msg: "Blog Silindi!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Hata oluştu!",
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

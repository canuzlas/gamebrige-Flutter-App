import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamebrige/src/screens/appMain/editProfilePage/state/editProfilePage_state.dart';
import 'package:gamebrige/src/screens/appMain/myProfilePage/state/myprofile_page_state.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePageController {
  late bool possibleName = true;
  late bool possibleUserName = true;
  late SharedPreferences prefs;

  getSharedPrafences() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  String? validateName(String? value) {
    String pattern = r"^([a-zA-Z\xC0-\uFFFF]{2,25}[ \-\']{0,1}){1,2}$";
    final regex = RegExp(pattern);

    if (value!.isNotEmpty && !regex.hasMatch(value)) {
      possibleName = false;
      return 'Adınız minimum 2 maximum 25 karakter olabilir\nYalnızca "-" özel işaret kullanılabilir\nYalnızca küçük büyük harf kullanabilirsin\nKullanıcı adınız harf ile başlamalı';
    } else {
      value!.isEmpty ? possibleName = false : possibleName = true;
      return null;
    }
  }

  String? validateUsername(String? value) {
    String pattern = r'^[A-Za-z][A-Za-z0-9_]{6,18}$';
    final regex = RegExp(pattern);
    if (value!.isNotEmpty && !regex.hasMatch(value)) {
      possibleUserName = false;
      return 'Kullanıcı adınız min 6 max 18 karakter olabilir\nTürkçe karakter kullanmayıız\nYalnızca "_" özel işaret kullanılabilir\nYalnızca küçük büyük harf ve rakam kullanabilirsin\nKullanıcı adınız harf ile başlamalı';
    } else {
      value!.isEmpty ? possibleUserName = false : possibleUserName = true;
      return null;
    }
  }

  updateProfile(name, username, user) async {
    if (possibleName && possibleUserName) {
      if (((username == user["username"] && name == user["name"]) &&
          (possibleName && possibleUserName))) {
        Fluttertoast.showToast(
            msg: "Değişiklik yapmadınız",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      } else {
        var data = await postProfilData(name, username, user);
        return data;
      }
    } else {
      Fluttertoast.showToast(
          msg: "Geçersiz ad veya kullanıcı adı",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.transparent,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
  }

  postProfilData(name, username, user) async {
    await getSharedPrafences();
    var url = "${dotenv.env['API_URL']!}api/updateprofile";
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appId': dotenv.env['APP_ID'],
          'token': prefs.getString("token"),
          "JWT_SECRET": dotenv.env['JWT_SECRET'],
          'name': name,
          'username': username,
          'user': user
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
      return false;
    } else {
      if (decodedResponse['tokenError'] != null || decodedResponse['error']) {
        Fluttertoast.showToast(
            msg: "Geçersiz kullanıcı adı veya geçersiz token.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      } else {
        Fluttertoast.showToast(
            msg: "Profil güncellendi",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            fontSize: 16.0);
        prefs.setString("user", jsonEncode(decodedResponse["user"]));
        return true;
      }
    }
  }

  changeProfilePhoto(ppname) async {
    await getSharedPrafences();
    var url = "${dotenv.env['API_URL']!}api/changepp";
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appId': dotenv.env['APP_ID'],
          'token': prefs.getString("token"),
          "JWT_SECRET": dotenv.env['JWT_SECRET'],
          "user": jsonDecode(prefs.getString("user").toString()),
          'ppname': ppname
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
      return false;
    } else {
      if (decodedResponse['tokenError'] != null || decodedResponse['error']) {
        Fluttertoast.showToast(
            msg: "Geçersiz token veya hata oluştu.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      } else {
        Fluttertoast.showToast(
            msg: "Profil resmi değişti.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            fontSize: 16.0);
        print(jsonEncode(decodedResponse["user"]));
        prefs.setString("user", jsonEncode(decodedResponse["user"]));
        return true;
      }
    }
  }

  Future<void> showPpP(user, context, ref) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
          title: const Center(child: Text('Birini Seç')),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (user["photo"] != "girl1.jpeg") {
                          await changeProfilePhoto("girl1.jpeg");
                          await ref.refresh(userFutureProvider);
                          await ref.refresh(myProfilePageFutureProvider);
                          Navigator.of(context).pop();
                        }
                        return;
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 5),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            "assets/images/girl1.jpeg",
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (user["photo"] != "girl2.jpeg") {
                          await changeProfilePhoto("girl2.jpeg");
                          await ref.refresh(userFutureProvider);
                          await ref.refresh(myProfilePageFutureProvider);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 5.0, right: 5),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            "assets/images/girl2.jpeg",
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (user["photo"] != "girl3.jpeg") {
                          await changeProfilePhoto("girl3.jpeg");
                          await ref.refresh(userFutureProvider);
                          await ref.refresh(myProfilePageFutureProvider);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 5.0, right: 15),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            "assets/images/girl3.jpeg",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (user["photo"] != "1.jpeg") {
                            await changeProfilePhoto("1.jpeg");
                            await ref.refresh(userFutureProvider);
                            await ref.refresh(myProfilePageFutureProvider);
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 5),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                              "assets/images/1.jpeg",
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (user["photo"] != "2.jpeg") {
                            await changeProfilePhoto("2.jpeg");
                            await ref.refresh(userFutureProvider);
                            await ref.refresh(myProfilePageFutureProvider);
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                              "assets/images/2.jpeg",
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (user["photo"] != "3.jpeg") {
                            await changeProfilePhoto("3.jpeg");
                            await ref.refresh(userFutureProvider);
                            await ref.refresh(myProfilePageFutureProvider);
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 15),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                              "assets/images/3.jpeg",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

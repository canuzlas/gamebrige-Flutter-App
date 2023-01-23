import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appStartPage.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  var users = [];
  var bestusers = [];
  late SharedPreferences prefs;

  late var token;
  late var user;

  Future<bool> _onWillPop() async {
    return false;
  }

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    //print(prefs.getString("user"));
  }

  searchUser(token, userid, txt) async {
    var url = "${dotenv.env['API_URL']!}api/searchperson";
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
          'userid': userid,
          "word": txt
        },
      ),
    );
    var decodedResponse = jsonDecode(response.body);
    //print(decodedResponse);
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
        if (decodedResponse["error"] == true) {
          Fluttertoast.showToast(
              msg: "Hata oluştu !",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          setState(() {
            users = decodedResponse['users'];
          });
        }
      }
    }
  }

  getBestUsers(token, userid) async {
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
          'userid': userid,
        },
      ),
    );
    var decodedResponse = jsonDecode(response.body);
    //print(decodedResponse);
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
        if (decodedResponse["error"] == true) {
          Fluttertoast.showToast(
              msg: "Hata oluştu !",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          setState(() {
            bestusers = decodedResponse['users'];
          });
        }
      }
    }
  }

  followPerson(token, userid, willfollowid) async {
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
          'user_id': userid,
          'willfollowpersonid': willfollowid,
        },
      ),
    );
    var decodedResponse = jsonDecode(response.body);
    //print(decodedResponse);
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

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
    token = ref.read(stoken);
    var getuser = ref.read(suser);
    user = jsonDecode(getuser);
    getBestUsers(token, user["_id"]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
          body: Column(
            children: [
              //header
              SafeArea(
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "GAMEBRIGE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/BlogShare');
                        },
                        icon: const Icon(Icons.add),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.message_outlined),
                      ),
                    ],
                  ),
                ),
              ),
              //search
              Container(
                margin: EdgeInsets.only(top: 0),
                width: 300,
                //margin: const EdgeInsets.only(top: 120),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Bir kullanıcı ara',
                        ),
                        style: TextStyle(color: Colors.black),
                        onChanged: (txt) {
                          setState(() {
                            txt.isEmpty
                                ? users = []
                                : searchUser(token, user["_id"], txt);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              //users
              Flexible(
                child: Container(
                  width: 300,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: users.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/OtherProfile",
                              arguments: {"user_id": users[i]["_id"]});
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(203, 241, 245, 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                    users[i]["photo"] == false
                                        ? "assets/images/defaultpp.jpeg"
                                        : "assets/images/defaultpp.jpeg",
                                  ),
                                ),
                              ),
                              Text(
                                users[i]["username"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: OutlinedButton(
                                  onPressed: () {
                                    followPerson(
                                        token, user["_id"], users[i]["_id"]);
                                  },
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.transparent),
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.all(8.0)),
                                      elevation: MaterialStatePropertyAll(1.0),
                                      side: MaterialStatePropertyAll(BorderSide(
                                          width: 1.0, color: Colors.white))),
                                  child: const Text(
                                    "Takip Et",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              //önerilenler
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Önerilen Kullanıcılar",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              bestusers.isEmpty
                  ? Container(
                      height: 300,
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 100,
                      ),
                    )
                  : Flexible(
                      child: Container(
                        width: 300,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: bestusers.length,
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/OtherProfile",
                                    arguments: {
                                      "user_id": bestusers[i]["_id"]
                                    });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color.fromRGBO(203, 241, 245, 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: AssetImage(
                                          bestusers[i]["photo"] == false
                                              ? "assets/images/defaultpp.jpeg"
                                              : "assets/images/defaultpp.jpeg",
                                        ),
                                      ),
                                    ),
                                    Text(
                                      bestusers[i]["username"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          followPerson(token, user["_id"],
                                              bestusers[i]["_id"]);
                                        },
                                        style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.transparent),
                                            padding: MaterialStatePropertyAll(
                                                EdgeInsets.all(8.0)),
                                            elevation:
                                                MaterialStatePropertyAll(1.0),
                                            side: MaterialStatePropertyAll(
                                                BorderSide(
                                                    width: 1.0,
                                                    color: Colors.white))),
                                        child: const Text(
                                          "Takip Et",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ],
          )),
    );
  }
}

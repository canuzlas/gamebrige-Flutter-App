import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../appMain/appStartPage.dart';

class SendMessagePage extends ConsumerStatefulWidget {
  const SendMessagePage({Key? key}) : super(key: key);

  @override
  ConsumerState<SendMessagePage> createState() => _SendMessagePageState();
}

class _SendMessagePageState extends ConsumerState<SendMessagePage> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  late SharedPreferences prefs;
  late String fbuser;
  late List users = [];
  var gettingData = true;
  late var user;
  late var token;

  getAllUser(token, userid) async {
    var url = "${dotenv.env['API_URL']!}api/getalluserfromarray";
    //apiden blogları alıyoruz
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appId': dotenv.env['APP_ID'],
          'token': token,
          '_id': userid,
          'following_array': user["following"],
        }));
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
        setState(() {
          gettingData = false;
          users = decodedResponse["users"];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    database.databaseURL = "https://gamebrige-default-rtdb.firebaseio.com";
    var res = ref.read(suser);
    token = ref.read(stoken);
    user = jsonDecode(res);

    getAllUser(token, user["_id"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
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
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        const Text(
                          "Mesaj Gönder",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications),
                        ),
                      ],
                    ),
                  ),
                ),
                gettingData
                    ? Container(
                        height: 300,
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white,
                          size: 100,
                        ),
                      )
                    : users.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "Kimseyi Takip Etmiyorsun.",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          )
                        : Flexible(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                getAllUser(token, user["_id"]);
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.all(10),
                                itemCount: users.length,
                                itemBuilder: (context, i) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/MessagingPage",
                                          arguments: users[i]);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      padding: const EdgeInsets.all(15),
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: const Color.fromRGBO(
                                            203, 241, 245, 0.8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black12.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 35,
                                            backgroundImage: AssetImage(
                                              users[i]["photo"] == false
                                                  ? "assets/images/defaultpp.jpeg"
                                                  : "assets/images/defaultpp.jpeg",
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Text(
                                                  users[i]["username"]
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                              ),
                                              Container(
                                                child: Text(
                                                  users[i]["name"].toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
              ],
            )
          ],
        ),
      ),
    );
  }
}

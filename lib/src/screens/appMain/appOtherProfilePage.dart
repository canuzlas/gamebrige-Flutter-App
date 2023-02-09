import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../appMain/appStartPage.dart';

class OtherProfilePage extends ConsumerStatefulWidget {
  late var person_id;
  OtherProfilePage({Key? key, required this.person_id}) : super(key: key);

  @override
  ConsumerState<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends ConsumerState<OtherProfilePage> {
  bool gettingData = true;
  late var token;
  late var user;
  late var person = {};
  late bool isPersonFollowing = false;

  late SharedPreferences prefs;

  var blogs = [];

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    //print(prefs.getString("user"));
  }

  getMyBlogs(token, id) async {
    var url = "${dotenv.env['API_URL']!}api/getmyblogs";
    //apiden blogları alıyoruz
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appId': dotenv.env['APP_ID'],
          'token': token,
          '_id': id,
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
          blogs = decodedResponse['blogs'];
        });
      }
    }
  }

  getPersonData(token, id) async {
    var url = "${dotenv.env['API_URL']!}api/getpersondata";
    //apiden blogları alıyoruz
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appId': dotenv.env['APP_ID'],
          'token': token,
          '_id': id,
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
          person = decodedResponse['person'];
        });
      }
    }
  }

  _reportThisPerson() async {
    var url = "${dotenv.env['API_URL']!}api/report/person";
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appId': dotenv.env['APP_ID'],
          'token': token,
          'reported_id': widget.person_id["user_id"],
          'reporting_person': user["_id"]
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
        if (decodedResponse['error'] == true) {
          Fluttertoast.showToast(
              msg: "Hata!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Kişi Bildirildi !",
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
              msg: "Takipten Çıkıldı",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              fontSize: 16.0);

          suser = Provider((ref) => jsonEncode(decodedResponse["user"]));
          prefs.setString("user", jsonEncode(decodedResponse["user"]));
          setState(() {
            isPersonFollowing = false;
          });
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
            //print(jsonEncode(decodedResponse["user"]));
            suser = Provider((ref) => jsonEncode(decodedResponse["user"]));
            prefs.setString("user", jsonEncode(decodedResponse["user"]));
            setState(() {
              isPersonFollowing = true;
            });
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
    var res = ref.read(suser);
    user = jsonDecode(res);

    getPersonData(token, widget.person_id["user_id"]);
    getMyBlogs(token, widget.person_id["user_id"]);
    setState(() {
      user["following"].contains(widget.person_id["user_id"])
          ? isPersonFollowing = true
          : isPersonFollowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: Border(bottom: BorderSide(color: Colors.white, width: 1)),
          elevation: 0.2,
          actions: [
            PopupMenuButton(
                icon: const Icon(Icons.error_outline),
                color: Colors.red,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () {
                        _reportThisPerson();
                      },
                      child: const Text(
                        "Hesabı Şikayet Et",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ];
                })
          ],
          backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text(
            "GAMEBRIGE",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          ),
        ),
        backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
        body: Column(
          children: [
            person.isEmpty
                ? Center(
                    child: Container(
                      height: 300,
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  )
                :
                //profile
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //fotoğraf cart curt
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 10, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: AssetImage(
                                person["photo"] == false
                                    ? "assets/images/defaultpp.jpeg"
                                    : "assets/images/defaultpp.jpeg",
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  blogs.length.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Gönderi",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                            Column(
                              children: [
                                Text(person["followers"].length.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("Takipçi",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                            Column(
                              children: [
                                Text((person["following"].length).toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("Takip",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ],
                        ),
                      ),
                      //kullanıcıadı
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          person["username"],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      //katılma tarihi
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 0),
                        child: Text(
                          "Katılma tarihi: ${person["createdAt"].substring(0, 10)}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      //buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isPersonFollowing
                              ? Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.all(20),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      followPerson(
                                          token, user["_id"], person["_id"]);
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Color.fromRGBO(
                                                    203, 241, 245, 1)),
                                        padding: MaterialStatePropertyAll(
                                            EdgeInsets.all(5.0)),
                                        elevation:
                                            MaterialStatePropertyAll(1.0),
                                        side: MaterialStatePropertyAll(
                                            BorderSide(
                                                width: 1.0,
                                                color: Colors.white))),
                                    child: const Text(
                                      "Takipten Çık",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.redAccent),
                                    ),
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.all(20),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      followPerson(
                                          token, user["_id"], person["_id"]);
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Color.fromRGBO(
                                                    203, 241, 245, 1)),
                                        padding: MaterialStatePropertyAll(
                                            EdgeInsets.all(5.0)),
                                        elevation:
                                            MaterialStatePropertyAll(1.0),
                                        side: MaterialStatePropertyAll(
                                            BorderSide(
                                                width: 1.0,
                                                color: Colors.white))),
                                    child: const Text(
                                      "Takip Et",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black),
                                    ),
                                  ),
                                ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.all(20),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  "/MessagingPage",
                                  arguments: {"fbuid": person["fbuid"]},
                                );
                              },
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromRGBO(203, 241, 245, 1)),
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.all(5.0)),
                                  elevation: MaterialStatePropertyAll(1.0),
                                  side: MaterialStatePropertyAll(BorderSide(
                                      width: 1.0, color: Colors.white))),
                              child: const Text(
                                "Mesaj Gönder",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
            Center(
              child: Container(
                margin: EdgeInsets.all(15),
                child: Text("PAYLAŞILAN BLOGLAR"),
              ),
            ),
            // blogs
            gettingData
                ? Container(
                    height: 300,
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 100,
                    ),
                  )
                : blogs.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            "Hiç gönderisi yok.",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    : Flexible(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            getMyBlogs(token, person["_id"]);
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: blogs.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "/ReadSelectedBlog",
                                      arguments: {"blog_id": blogs[i]["_id"]});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(15),
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color:
                                        const Color.fromRGBO(203, 241, 245, 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 100),
                                        child: Image.asset(
                                          "assets/images/startpage-bg.jpeg",
                                          fit: BoxFit.fill,
                                          width: 100,
                                        ),
                                      ),
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              alignment: Alignment.topCenter,
                                              padding: const EdgeInsets.only(
                                                left: 20,
                                                top: 0,
                                              ),
                                              child: Text(
                                                "${blogs[i]["blog_title"]}",
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                maxLines: 4,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Flexible(
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 5,
                                                                left: 8),
                                                        child: CircleAvatar(
                                                          radius: 15,
                                                          backgroundImage:
                                                              AssetImage(
                                                            person["photo"] ==
                                                                    false
                                                                ? "assets/images/defaultpp.jpeg"
                                                                : "assets/images/defaultpp.jpeg",
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          blogs[i][
                                                              "blog_author_username"],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: true,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  "${blogs[i]["createdAt"].substring(0, 10)}",
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
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
        ));
  }
}

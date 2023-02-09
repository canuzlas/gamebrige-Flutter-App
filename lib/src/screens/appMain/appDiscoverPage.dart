import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../appMain/appStartPage.dart';

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  bool gettingData = true;
  late SharedPreferences prefs;
  var blogs = [];
  late var token;
  late var user;

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    //print(prefs.getString("user"));
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  getAllBlogs(token) async {
    var url = "${dotenv.env['API_URL']!}api/getallblogs";
    //apiden blogları alıyoruz
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'appId': dotenv.env['APP_ID'], 'token': token}));
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

  @override
  void initState() {
    super.initState();
    token = ref.read(stoken);
    var res = ref.read(suser);
    user = jsonDecode(res);
    //print(user);
    getSharedPreferences();
    getAllBlogs(token);
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
                        onPressed: () {
                          Navigator.pushNamed(context, '/AllMessages');
                        },
                        icon: const Icon(Icons.message_outlined),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text("Tüm dünyadan senin için seçtiklerimiz."),
              ),
              //blogs
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
                              "Görüntülenecek blog bulunamadı. Lütfen keşfet kısmına göz at.",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        )
                      : Flexible(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              getAllBlogs(token);
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: blogs.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/ReadSelectedBlog",
                                        arguments: {
                                          "blog_id": blogs[i]["_id"]
                                        });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.all(15),
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color.fromRGBO(
                                          203, 241, 245, 1),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  maxLines: 4,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Flexible(
                                                    child: GestureDetector(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 5),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 15,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                  blogs[i]["blog_author_photo"] ==
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
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        blogs[i]["blog_author"] !=
                                                                user["_id"]
                                                            ? Navigator
                                                                .pushNamed(
                                                                context,
                                                                "/OtherProfile",
                                                                arguments: {
                                                                  "user_id": blogs[
                                                                          i][
                                                                      "blog_author"]
                                                                },
                                                              )
                                                            : null;
                                                      },
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
          )),
    );
  }
}

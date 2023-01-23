import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appStartPage.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool gettingData = true;
  late var token;
  late var user;
  late SharedPreferences prefs;

  var blogs = [];

  Future<bool> _onWillPop() async {
    return false;
  }

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    //print(prefs.getString("user"));
  }

  getMyBlogs(token, userid) async {
    var url = "${dotenv.env['API_URL']!}api/getmyblogs";
    //apiden blogları alıyoruz
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appId': dotenv.env['APP_ID'],
          'token': token,
          '_id': userid,
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

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
    token = ref.read(stoken);
    var getuser = ref.read(suser);
    user = jsonDecode(getuser);
    getMyBlogs(token, user["_id"]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          drawer: Drawer(
            backgroundColor: Color.fromRGBO(203, 241, 245, 1),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(166, 227, 233, 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage(
                          user["photo"] == false
                              ? "assets/images/defaultpp.jpeg"
                              : "assets/images/defaultpp.jpeg",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          user["username"],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('Blog Paylaş'),
                  onTap: () {
                    Navigator.pushNamed(context, '/BlogShare');
                  },
                ),
                ListTile(
                  title: const Text('Profili Düzenle'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text(
                    "Çıkış Yap",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    prefs.remove("user");
                    Navigator.pushNamed(context, "/Landing");
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            shape: Border(bottom: BorderSide(color: Colors.white, width: 1)),
            elevation: 0.2,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/BlogShare');
                },
                icon: const Icon(Icons.add),
                color: Colors.black,
              ),
              Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  color: Colors.black,
                  icon: const Icon(Icons.menu),
                );
              })
            ],
            backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: const Text(
              "GAMEBRIGE",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
          ),
          backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
          body: Column(
            children: [
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
                            user["photo"] == false
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
                            const Text("Gönderi",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        Column(
                          children: [
                            Text(user["followers"].length.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Takipçi",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        Column(
                          children: [
                            Text((user["following"].length).toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Takip",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                  ),
                  //kullanıcıadı
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      user["username"],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  //katılma tarihi
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 0),
                    child: Text(
                      "Katılma tarihi: ${user["createdAt"].substring(0, 10)}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  //profil düzenle blog paylaş
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromRGBO(203, 241, 245, 1)),
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.all(5.0)),
                              elevation: MaterialStatePropertyAll(1.0),
                              side: MaterialStatePropertyAll(
                                  BorderSide(width: 1.0, color: Colors.white))),
                          child: const Text(
                            "Profili Düzenle",
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/BlogShare');
                          },
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromRGBO(203, 241, 245, 1)),
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.all(5.0)),
                              elevation: MaterialStatePropertyAll(1.0),
                              side: MaterialStatePropertyAll(
                                  BorderSide(width: 1.0, color: Colors.white))),
                          child: const Text(
                            "Blog Paylaş",
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                              "Hiç gönderin yok.",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        )
                      : Flexible(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              getMyBlogs(token, user["_id"]);
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
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 5),
                                                        child: CircleAvatar(
                                                          radius: 15,
                                                          backgroundImage:
                                                              AssetImage(
                                                            user["photo"] ==
                                                                    false
                                                                ? "assets/images/defaultpp.jpeg"
                                                                : "assets/images/defaultpp.jpeg",
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        blogs[i][
                                                            "blog_author_username"],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
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

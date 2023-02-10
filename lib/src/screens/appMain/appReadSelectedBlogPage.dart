import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamebrige/src/sm/sm_with_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ReadSelectedBlogPage extends ConsumerStatefulWidget {
  late var blogId;
  ReadSelectedBlogPage({Key? key, required this.blogId}) : super(key: key);

  @override
  ConsumerState<ReadSelectedBlogPage> createState() =>
      _ReadSelectedBlogPageState();
}

class _ReadSelectedBlogPageState extends ConsumerState<ReadSelectedBlogPage> {
  late bool liked = false;
  late var blog = {};
  late var author = {};
  late var user;
  late var token;

  _likeblog() {
    setState(() {
      liked = !liked;
    });
    print("dede");
  }

  getBlog(token) async {
    var url = "${dotenv.env['API_URL']!}api/getblog";
    //apiden bloğu alıyoruz
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appId': dotenv.env['APP_ID'],
          'token': token,
          'blog_id': widget.blogId["blog_id"]
        }));
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
        if (decodedResponse['blog'] == false) {
          Fluttertoast.showToast(
              msg: "Blog bulunamadı!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          //print(decodedResponse);
          setState(() {
            blog = decodedResponse['blog'];
            author = decodedResponse['author'];
          });
        }
      }
    }
  }

  _reportThisBlog() async {
    var url = "${dotenv.env['API_URL']!}api/report/blog";
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appId': dotenv.env['APP_ID'],
          'token': token,
          'blog_id': widget.blogId["blog_id"],
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
              msg: "Blog Bildirildi !",
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

  @override
  void initState() {
    super.initState();
    print(widget.blogId["blog_id"]);
    token = ref.read(stoken);
    var res = ref.read(suser);
    user = jsonDecode(res);
    getBlog(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
      body: Column(
        children: [
          //header
          SafeArea(
            child: Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10, right: 10),
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
                      icon: Icon(Icons.arrow_back)),
                  const Text(
                    "GAMEBRIGE",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
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
          //blog
          Flexible(
            child: Container(
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.only(
                  bottom: 50, left: 10, right: 10, top: 20),
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromRGBO(203, 241, 245, 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  //author
                  author.isEmpty
                      ? Flexible(
                          child: Container(
                            height: 300,
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromRGBO(203, 241, 245, 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ]),
                          child: GestureDetector(
                            onTap: () {
                              author["_id"] != user["_id"]
                                  ? Navigator.pushNamed(
                                      context,
                                      "/OtherProfile",
                                      arguments: {"user_id": author["_id"]},
                                    )
                                  : null;
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundImage: AssetImage(
                                      author["photo"] == false
                                          ? "assets/images/defaultpp.jpeg"
                                          : "assets/images/defaultpp.jpeg",
                                    ),
                                  ),
                                ),
                                Text(
                                  author["username"],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                PopupMenuButton(
                                    icon: const Icon(Icons.accessibility),
                                    color:
                                        const Color.fromRGBO(113, 201, 206, 1),
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          onTap: () {
                                            _reportThisBlog();
                                          },
                                          child: const Text(
                                            "Bloğu Şikayet Et",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ];
                                    }),
                              ],
                            ),
                          ),
                        ),
                  //data
                  blog.isEmpty
                      ? Flexible(
                          child: Container(
                            height: 300,
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                        )
                      : Container(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            blog["blog_title"],
                            softWrap: true,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                  blog.isEmpty
                      ? Flexible(
                          child: Container(
                            height: 300,
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                        )
                      : Flexible(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(10),
                            child: Text(blog["blog_text"]),
                          ),
                        ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {
                        _likeblog();
                      },
                      icon: liked
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_border),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

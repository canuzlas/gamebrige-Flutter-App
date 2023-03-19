import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamebrige/src/sm/sm_with_riverpod.dart';
import 'package:http/http.dart' as http;

class BlogUpdatePage extends ConsumerStatefulWidget {
  late var blog;
  BlogUpdatePage({Key? key, required this.blog}) : super(key: key);

  @override
  ConsumerState<BlogUpdatePage> createState() => _BlogUpdatePageState();
}

class _BlogUpdatePageState extends ConsumerState<BlogUpdatePage> {
  late String title = widget.blog["blog_title"];
  late String text = widget.blog["blog_text"];
  late bool keyboard = false;
  bool _keyboardVisible = false;
  late var token;
  late var user;

  updateBlog(context, token, user) async {
    var url = "${dotenv.env['API_URL']!}api/editblog";
    //apiden blogları alıyoruz
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appId': dotenv.env['APP_ID'],
          'token': token,
          "JWT_SECRET": dotenv.env['JWT_SECRET'],
          'blog': widget.blog,
          'title': title,
          'text': text
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
              msg: "Beklenmedik Hata.!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "bloğunuz düzenlendi.!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pushNamedAndRemoveUntil(
              context, '/Tab', (Route<dynamic> route) => false);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    token = ref.read(stoken);
    var getuser = ref.read(suser);
    user = jsonDecode(getuser);
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Spacer(),
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
            Flexible(
              child: Container(
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.only(
                      bottom: 50, left: 10, right: 10, top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromRGBO(203, 241, 245, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      //title
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Form(
                            child: TextFormField(
                              initialValue: widget.blog["blog_title"],
                              maxLength: 60,
                              maxLines: null,
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
                                labelText: 'Blog Başlığı',
                              ),
                              style: TextStyle(color: Colors.black),
                              onChanged: (txt) {
                                setState(() {
                                  title = txt;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      //text
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(top: 0),
                          //margin: const EdgeInsets.only(top: 120),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Form(
                                child: SingleChildScrollView(
                                  child: TextFormField(
                                    initialValue: widget.blog["blog_text"],
                                    maxLength: 10000,
                                    maxLines: _keyboardVisible ? 13 : 13,
                                    decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelText: 'Blog içeriğiniz',
                                    ),
                                    style: TextStyle(color: Colors.black),
                                    onChanged: (txt) {
                                      setState(() {
                                        text = txt;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //send button
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.all(10),
                        child: OutlinedButton(
                          onPressed: () {
                            title.isEmpty || text.isEmpty
                                ? Fluttertoast.showToast(
                                    msg:
                                        "başlık veya içerik kısmı boş bırakılamaz.!",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.transparent,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                                : updateBlog(context, token, user);
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent),
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.all(8.0)),
                              elevation: MaterialStatePropertyAll(1.0),
                              side: MaterialStatePropertyAll(
                                  BorderSide(width: 1.0, color: Colors.white))),
                          child: const Text(
                            "Düzenle",
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}

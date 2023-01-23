import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'appStartPage.dart';

class BlogSharePage extends ConsumerStatefulWidget {
  const BlogSharePage({Key? key}) : super(key: key);

  @override
  ConsumerState<BlogSharePage> createState() => _BlogSharePageState();
}

class _BlogSharePageState extends ConsumerState<BlogSharePage> {
  late String title = "";
  late String text = "";
  late bool keyboard = false;
  bool _keyboardVisible = false;
  late var token;
  late var user;

  shareBlog(token, user) async {
    var url = "${dotenv.env['API_URL']!}api/saveblog";
    //apiden blogları alıyoruz
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appId': dotenv.env['APP_ID'],
          'token': token,
          'user': user,
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
              msg: "bloğunuz paylaşıldı.!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pushNamed(context, "/Tab");
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
            const Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                  "Yapacağın paylaşımın oyunlarla ilgili olduğundan emin ol :)"),
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
                      Container(
                        margin: EdgeInsets.only(top: 0),

                        //margin: const EdgeInsets.only(top: 120),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Form(
                              child: TextField(
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
                      ),
                      //text
                      Container(
                        margin: EdgeInsets.only(top: 0),
                        //margin: const EdgeInsets.only(top: 120),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Form(
                              child: SingleChildScrollView(
                                child: TextField(
                                  maxLength: 10000,
                                  maxLines: _keyboardVisible ? 5 : 15,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(color: Colors.black),
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
                                : shareBlog(token, user);
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
                            "Blog Paylaş",
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

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

class MessagingPage extends ConsumerStatefulWidget {
  late var messagingUser;
  MessagingPage({Key? key, required this.messagingUser}) : super(key: key);

  @override
  ConsumerState<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends ConsumerState<MessagingPage> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  late SharedPreferences prefs;
  late String messagetxt = "";
  late List<dynamic> messages = [];
  late List<dynamic> messagesreferance = [];
  var gettingData = true;
  late var user;
  late var messagingPerson;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  sendMessage() async {
    sendMessageTwo();
    final DatabaseReference reference = FirebaseDatabase.instance
        .ref()
        .child('Messages/${user["fbuid"]}/${widget.messagingUser["fbuid"]}');
    DatabaseReference newPostRef = reference.push();
    newPostRef.set({
      "toWho": messagingPerson["username"],
      "message": messagetxt,
      "sender_username": user["username"],
      "sender_name": user["name"],
      "sender_photo": user["photo"],
      "sender_fbuid": user["fbuid"],
    });

    messagetxt = "";
    messages.isNotEmpty
        ? _scrollController.animateTo(
            0.0,
            curve: Curves.bounceInOut,
            duration: const Duration(milliseconds: 300),
          )
        : null;
  }

  void sendMessageTwo() {
    final DatabaseReference reference1 = FirebaseDatabase.instance
        .ref()
        .child('Messages/${widget.messagingUser["fbuid"]}/${user["fbuid"]}');
    DatabaseReference newPostRef1 = reference1.push();
    newPostRef1.set({
      "toWho": messagingPerson["username"],
      "message": messagetxt,
      "sender_username": user["username"],
      "sender_name": user["name"],
      "sender_photo": user["photo"],
      "sender_fbuid": user["fbuid"],
    });
  }

  getMessaginPersonData(token, fbuid) async {
    var url = "${dotenv.env['API_URL']!}api/getmessagingpersondata";
    //apiden blogları alıyoruz
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appId': dotenv.env['APP_ID'],
          'token': token,
          'person_fbuid': fbuid,
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
          if (mounted) {
            setState(() {
              gettingData = false;
              messagingPerson = decodedResponse["user"];
            });
          }
        }
      }
    }
  }

  createMessageListener() {
    database.databaseURL = "https://gamebrige-default-rtdb.firebaseio.com";
    database
        .ref('Messages/${user["fbuid"]}/${widget.messagingUser["fbuid"]}')
        .onChildAdded
        .listen((event) {
      if (mounted) {
        setState(() {
          messagesreferance.add(event.snapshot.value);
          messages = messagesreferance.reversed.toList();
        });
      }
    });
  }

  _deleteMessage() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref('Messages/${user["fbuid"]}/${widget.messagingUser["fbuid"]}');
    await ref.remove();
    Fluttertoast.showToast(
        msg: "Konuşma Silindi.!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.transparent,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pushNamed(context, '/Tab');
  }

  void initAsyncStorage() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    var res = ref.read(suser);
    user = jsonDecode(res);
    var token = ref.read(stoken);
    initAsyncStorage();
    getMessaginPersonData(token, widget.messagingUser["fbuid"]);
    createMessageListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 120),
              child: Column(
                children: [
                  //header
                  SafeArea(
                    child: gettingData
                        ? Center(
                            child: SizedBox(
                              height: 300,
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white,
                                size: 100,
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.white),
                              ),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back_outlined),
                                ),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                    messagingPerson["photo"] == false
                                        ? "assets/images/defaultpp.jpeg"
                                        : "assets/images/defaultpp.jpeg",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 5),
                                  child: Column(
                                    children: [
                                      Text(
                                        messagingPerson["username"].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        messagingPerson["name"].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                PopupMenuButton(
                                    icon: const Icon(Icons.settings_outlined),
                                    color:
                                        const Color.fromRGBO(113, 201, 206, 1),
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          onTap: () {
                                            messages.isNotEmpty
                                                ? _deleteMessage()
                                                : Fluttertoast.showToast(
                                                    msg:
                                                        "Olmayan Konuşmayı Silemezsin.!",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                          },
                                          child: const Text(
                                            "Konuşmayı sil",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ];
                                    })
                              ],
                            ),
                          ),
                  ),
                  //message box
                  gettingData
                      ? Center(
                          child: SizedBox(
                            height: 300,
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                        )
                      : messages.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  "Hiç Mesajınız Yok, Hemen Mesajlaşmaya Başlayın :)",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            )
                          : Flexible(
                              child: ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                reverse: true,
                                padding: const EdgeInsets.all(10),
                                itemCount: messages.length,
                                itemBuilder: (context, i) {
                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    child: messages[i]["sender_fbuid"] ==
                                            user["fbuid"]
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: const Color.fromRGBO(
                                                        203, 241, 245, 0.8),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black12
                                                            .withOpacity(0.2),
                                                        spreadRadius: 2,
                                                        blurRadius: 7,
                                                        offset: Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    messages[i]["message"]
                                                        .toString(),
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    right: 0.0, left: 10),
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: AssetImage(
                                                    "assets/images/defaultpp.jpeg",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 0.0, right: 10),
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: AssetImage(
                                                    "assets/images/defaultpp.jpeg",
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: const Color.fromRGBO(
                                                        203, 241, 245, 0.8),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black12
                                                            .withOpacity(0.2),
                                                        spreadRadius: 2,
                                                        blurRadius: 7,
                                                        offset: Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    messages[i]["message"]
                                                        .toString(),
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  );
                                },
                              ),
                            ),
                ],
              ),
            ),
            //messagebox
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              alignment: Alignment.bottomCenter,
              child: Form(
                child: TextFormField(
                  controller: _controller,
                  maxLength: 240,
                  maxLines: null,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _controller.clear();
                        messagetxt.isNotEmpty ? sendMessage() : null;
                      },
                      icon: const Icon(Icons.send),
                    ),
                    suffixIconColor: Colors.white60,
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Mesajın',
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (txt) {
                    setState(() {
                      messagetxt = txt;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

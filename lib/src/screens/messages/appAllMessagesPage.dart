import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamebrige/src/sm/sm_with_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllMessagesPage extends ConsumerStatefulWidget {
  const AllMessagesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AllMessagesPage> createState() => _AllMessagesPageState();
}

class _AllMessagesPageState extends ConsumerState<AllMessagesPage> {
  FirebaseDatabase database = FirebaseDatabase.instance;

  late SharedPreferences prefs;
  late List users;
  late List getAllMessageList = [];
  late List messages = [];
  var gettingData = true;
  late var user;
  var listener;

  _deleteMessage(message) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Messages/${user["fbuid"]}/${message["sender_id"]}");
    await ref.remove();
    Fluttertoast.showToast(
        msg: "Konuşma Silindi.!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.transparent,
        textColor: Colors.white,
        fontSize: 16.0);
    setState(() {
      messages.remove(message);
    });
  }

  createAllMessagesListener() async {
    var refMessages = [];
    database.databaseURL =
        "https://com-uzlas-gamebrige-default-rtdb.firebaseio.com/";
    listener = database
        .ref('Messages/${user["fbuid"]}')
        .orderByKey()
        .onValue
        .listen((event) async {
      if (event.snapshot.value != null) {
        messages.clear();
        var data = event.snapshot.value as Map;
        data.keys.forEach((element) async {
          var referanceMap = {};
          referanceMap = {};
          var lastMessage = await database
              .ref('Messages/${user["fbuid"]}/${element}')
              .orderByKey()
              .limitToLast(1)
              .get();
          var res = lastMessage.value as Map;
          referanceMap = {
            "delete": false,
            "sender_id": element.toString(),
            "messages": res.values.last["message"],
            "sender_username": res.values.last["sender_username"],
            "sender_photo": res.values.last["sender_photo"],
            "toWho": res.values.last["toWho"],
          };
          refMessages.add(referanceMap);
          setState(() {
            messages = refMessages;
            gettingData = false;
          });
        });
      } else {
        setState(() {
          gettingData = false;
          messages = [];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    var res = ref.read(suser);
    user = jsonDecode(res);
    createAllMessagesListener();
  }

  @override
  void dispose() {
    messages = [];
    gettingData = true;
    listener?.cancel();
    super.dispose();
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
                          "Tüm Sohbetler",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/SendMessage');
                          },
                          icon: const Icon(Icons.send),
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
                    : messages.isEmpty
                        ? Flexible(
                            child: ListView(children: const [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    "Hiç Mesajın Yok.",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ]),
                          )
                        : Flexible(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: messages.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/MessagingPage",
                                      arguments: {
                                        "fbuid": messages[i]["sender_id"]
                                      },
                                    );
                                  },
                                  onHorizontalDragUpdate: (details) {
                                    // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                                    int sensitivity = 1;
                                    if (details.delta.dx < -sensitivity &&
                                        messages[i]["delete"] == false) {
                                      setState(() {
                                        messages[i]["delete"] = true;
                                      });
                                    } else if (details.delta.dx > sensitivity &&
                                        messages[i]["delete"] == true) {
                                      setState(() {
                                        messages[i]["delete"] = false;
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    height: 90,
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
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: CircleAvatar(
                                            radius: 45,
                                            backgroundImage: AssetImage(
                                              messages[i]["sender_photo"] ==
                                                      false
                                                  ? "assets/images/defaultpp.jpeg"
                                                  : "assets/images/${messages[i]["sender_photo"]}",
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    messages[i]["toWho"] ==
                                                            user["username"]
                                                        ? messages[i][
                                                                "sender_username"]
                                                            .toString()
                                                        : messages[i]["toWho"],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  messages[i]["messages"]
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        messages[i]["delete"] == false
                                            ? Container()
                                            : Container(
                                                padding: EdgeInsets.zero,
                                                height: 90,
                                                color: Colors.redAccent,
                                                child: IconButton(
                                                  onPressed: () {
                                                    _deleteMessage(messages[i]);
                                                  },
                                                  icon: const Icon(
                                                      Icons.delete_outline),
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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

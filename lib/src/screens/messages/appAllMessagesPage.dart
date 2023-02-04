import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../appMain/appStartPage.dart';

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

  getAllMessage(_id) async {
    late List getAllMessageList = [];
    final snapshot =
        await FirebaseDatabase.instance.ref('Messages/${_id}').get();

    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value as Map;
      values.forEach((key, values) {
        late var referanceMap = {};
        late List referanceList = [];
        referanceList.clear();
        referanceMap = {};
        Map<dynamic, dynamic> invalues = values as Map;
        invalues.forEach((keyy, value) {
          referanceList.add(value);
          referanceMap = {
            "sender_id": key.toString(),
            "messages": referanceList
          };
          //print(referanceMap);
        });

        getAllMessageList.add(referanceMap);
        //print(getAllMessageList);
        //print(referanceMap);
      });
      //print(getAllMessageList);
      //print(getAllMessageList);
      setState(() {
        gettingData = false;
        messages = getAllMessageList;
        //print(getAllMessageList);
      });
    } else {
      setState(() {
        gettingData = false;
        messages = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //database.databaseURL = "https://gamebrige-default-rtdb.firebaseio.com";
    var res = ref.read(suser);
    user = jsonDecode(res);
    getAllMessage(user["fbuid"]);
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
                    : messages.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "Hiç Mesajın Yok.",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          )
                        : Flexible(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                getAllMessage(user["fbuid"]);
                              },
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
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      padding: const EdgeInsets.all(15),
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
                                          CircleAvatar(
                                            radius: 45,
                                            backgroundImage: AssetImage(
                                              messages[i]["messages"][0]
                                                          ["sender_photo"] ==
                                                      false
                                                  ? "assets/images/defaultpp.jpeg"
                                                  : "assets/images/defaultpp.jpeg",
                                            ),
                                          ),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    messages[i]["messages"][0]
                                                                ["toWho"] ==
                                                            user["username"]
                                                        ? messages[i]["messages"]
                                                                    [0][
                                                                "sender_username"]
                                                            .toString()
                                                        : messages[i]
                                                                ["messages"][0]
                                                            ["toWho"],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  messages[i]["messages"]
                                                      .last["message"]
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/otherProfilePageController.dart';

class OtherProfilePagePersonDatasPart extends StatefulWidget {
  final token;
  final user;
  final person_id;
  final blogs;
  const OtherProfilePagePersonDatasPart(
      {Key? key, this.token, this.user, this.person_id, this.blogs})
      : super(key: key);

  @override
  State<OtherProfilePagePersonDatasPart> createState() =>
      _OtherProfilePagePersonDatasPartState();
}

class _OtherProfilePagePersonDatasPartState
    extends State<OtherProfilePagePersonDatasPart> {
  OtherProfilePageController otherProfilePageController =
      OtherProfilePageController();
  late var person = {};
  late SharedPreferences prefs;
  bool isPersonFollowing = true;

  getPersonData() async {
    var refPrefs = await otherProfilePageController.getSharedPreferences();
    var refPerson = await otherProfilePageController.getPersonData(
        context, widget.token, widget.person_id["user_id"]);
    setState(() {
      prefs = refPrefs;
      person = refPerson;
      widget.user["following"].contains(widget.person_id["user_id"])
          ? isPersonFollowing = true
          : isPersonFollowing = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPersonData();
  }

  @override
  Widget build(BuildContext context) {
    return person.isEmpty
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
                padding: const EdgeInsets.only(left: 10, top: 10, right: 20),
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
                          widget.blogs.length.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Gönderi",
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    Column(
                      children: [
                        Text(person["followers"].length.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Takipçi",
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    Column(
                      children: [
                        Text((person["following"].length).toString(),
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
                  person["username"],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              otherProfilePageController.followPerson(
                                  context,
                                  widget.token,
                                  jsonEncode(widget.user),
                                  person["_id"]);
                              setState(() {
                                isPersonFollowing = false;
                              });
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
                              "Takipten Çık",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.redAccent),
                            ),
                          ),
                        )
                      : Container(
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.all(20),
                          child: OutlinedButton(
                            onPressed: () {
                              otherProfilePageController.followPerson(
                                  context,
                                  widget.token,
                                  jsonEncode(widget.user),
                                  person["_id"]);
                              setState(() {
                                isPersonFollowing = true;
                              });
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
                              "Takip Et",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
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
                          padding:
                              MaterialStatePropertyAll(EdgeInsets.all(5.0)),
                          elevation: MaterialStatePropertyAll(1.0),
                          side: MaterialStatePropertyAll(
                              BorderSide(width: 1.0, color: Colors.white))),
                      child: const Text(
                        "Mesaj Gönder",
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
  }
}

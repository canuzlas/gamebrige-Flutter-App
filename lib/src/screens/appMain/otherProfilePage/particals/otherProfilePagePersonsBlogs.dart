import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/otherProfilePageController.dart';

class OtherProfilePagePersonsBlogs extends StatefulWidget {
  final token;
  final user;
  final person_id;
  const OtherProfilePagePersonsBlogs(
      {Key? key, this.token, this.user, this.person_id})
      : super(key: key);

  @override
  State<OtherProfilePagePersonsBlogs> createState() =>
      _OtherProfilePagePersonsBlogsState();
}

class _OtherProfilePagePersonsBlogsState
    extends State<OtherProfilePagePersonsBlogs> {
  OtherProfilePageController otherProfilePageController =
      OtherProfilePageController();

  var blogs = [];
  bool gettingData = true;
  late SharedPreferences prefs;

  late var person = {};

  getPersonData() async {
    var refPrefs = await otherProfilePageController.getSharedPreferences();
    var refPerson = await otherProfilePageController.getPersonData(
        context, widget.token, widget.person_id["user_id"]);
    setState(() {
      prefs = refPrefs;
      person = refPerson;
    });
  }

  getBlogsData() async {
    var refBlogs = await otherProfilePageController.getThisUsersBlogs(
        context, widget.token, widget.person_id["user_id"]);
    setState(() {
      blogs = refBlogs;
      gettingData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getBlogsData();
    getPersonData();
  }

  @override
  Widget build(BuildContext context) {
    return gettingData
        ? Flexible(
            child: SizedBox(
              height: 300,
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 100,
              ),
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
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(15),
                        child: Text("PAYLAŞILAN BLOGLAR"),
                      ),
                    ),
                    Flexible(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          otherProfilePageController.getThisUsersBlogs(context,
                              widget.token, widget.person_id["user_id"]);
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
                                  color: const Color.fromRGBO(203, 241, 245, 1),
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
                                                  fontWeight: FontWeight.w900),
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
                                                          const EdgeInsets.only(
                                                              right: 5,
                                                              left: 8),
                                                      child: CircleAvatar(
                                                        radius: 15,
                                                        backgroundImage:
                                                            AssetImage(
                                                          person["photo"] ==
                                                                  "false"
                                                              ? "assets/images/defaultpp.jpeg"
                                                              : "assets/images/${person["photo"]}",
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
                                                        style: const TextStyle(
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
                ),
              );
  }
}

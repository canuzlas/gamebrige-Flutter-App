import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appMain/otherProfilePage/particals/otherProfilePageAppBar.dart';
import 'package:gamebrige/src/screens/appMain/otherProfilePage/particals/otherProfilePagePersonDatasPart.dart';
import 'package:gamebrige/src/screens/appMain/otherProfilePage/particals/otherProfilePagePersonsBlogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/otherProfilePageController.dart';

class OtherProfilePageScaffold extends StatefulWidget {
  final token;
  final user;
  final person_id;
  const OtherProfilePageScaffold(
      {Key? key, this.token, this.user, this.person_id})
      : super(key: key);

  @override
  State<OtherProfilePageScaffold> createState() =>
      _OtherProfilePageScaffoldState();
}

class _OtherProfilePageScaffoldState extends State<OtherProfilePageScaffold> {
  OtherProfilePageController otherProfilePageController =
      OtherProfilePageController();

  bool gettingData = true;
  bool isPersonFollowing = true;
  late var person = {};
  var blogs = [];
  late SharedPreferences prefs;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OtherProfilePageAppBar(
        token: widget.token,
        user: widget.user,
        person_id: widget.person_id,
      ),
      backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
      body: Column(
        children: [
          //profile
          OtherProfilePagePersonDatasPart(
            token: widget.token,
            user: widget.user,
            person_id: widget.person_id,
            blogs: blogs,
          ),

          // blogs
          OtherProfilePagePersonsBlogs(
            token: widget.token,
            user: widget.user,
            person_id: widget.person_id,
          )
        ],
      ),
    );
    ;
  }
}

import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appMain/myProfilePage/particals/myProfilePageAppBar.dart';
import 'package:gamebrige/src/screens/appMain/myProfilePage/particals/myProfilePageBlogsPart.dart';
import 'package:gamebrige/src/screens/appMain/myProfilePage/particals/myProfilePageDrawerMenu.dart';
import 'package:gamebrige/src/screens/appMain/myProfilePage/particals/myProfilePageUserProfilePart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/myProfilePageController.dart';

class MyProfilePageScaffold extends StatefulWidget {
  final bool gettingData;
  final token;
  final user;
  final prefs;
  final blogs;

  const MyProfilePageScaffold(
      {Key? key,
      this.token,
      this.user,
      this.blogs,
      required this.gettingData,
      this.prefs})
      : super(key: key);

  @override
  State<MyProfilePageScaffold> createState() => _MyProfilePageScaffoldState();
}

class _MyProfilePageScaffoldState extends State<MyProfilePageScaffold> {
  MyProfilePageController myProfilePageController = MyProfilePageController();
  late var prefs;

  Future<bool> _onWillPop() async {
    return false;
  }

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          drawer: MyProfilePageDrawerMenu(user: widget.user),
          appBar: MyProfilePageAppBar(),
          backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
          body: Column(
            children: [
              //profile
              MyProfilePageUserProfilePart(
                user: widget.user,
                blogs: widget.blogs,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Text("PAYLAŞILAN BLOGLAR"),
                ),
              ),
              // blogs
              (widget.blogs.isEmpty && widget.gettingData == false)
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Hiç gönderin yok.",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  : MyProfilePageBlogsPart(
                      user: widget.user,
                      token: widget.token,
                    )
            ],
          )),
    );
  }
}

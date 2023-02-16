import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/myProfilePage/controller/myProfilePageController.dart';
import 'package:gamebrige/src/screens/appMain/myProfilePage/particals/myProfilePageScaffold.dart';
import 'package:gamebrige/src/sm/sm_with_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  MyProfilePageController myProfilePageController = MyProfilePageController();
  bool gettingData = true;
  late var token;
  late var user;
  late SharedPreferences prefs;

  var blogs = [];

  getFutureData(context) async {
    var refPrefs = await myProfilePageController.getSharedPreferences();
    var refBlogs =
        await myProfilePageController.getMyBlogs(context, token, user["_id"]);
    setState(() {
      prefs = refPrefs;
      blogs = refBlogs;
      gettingData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    token = ref.read(stoken);
    var getuser = ref.read(suser);
    user = jsonDecode(getuser);
    getFutureData(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyProfilePageScaffold(
      token: token,
      user: user,
      blogs: blogs,
      gettingData: gettingData,
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/discoverPage/controller/discoverPageController.dart';
import 'package:gamebrige/src/screens/appMain/discoverPage/particals/discoverPageScaffold.dart';
import 'package:gamebrige/src/sm/sm_with_riverpod.dart';

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  DiscoverPageController discoverPageController = DiscoverPageController();
  late var token;
  late var user;
  late var prefs;
  var blogs = [];
  bool gettingData = true;

  getFutureData(context, token) async {
    var refprefs = await discoverPageController.getSharedPreferences();
    var refblogs = (await discoverPageController.getAllBlogs(context, token))!;
    setState(() {
      prefs = refprefs;
      blogs = refblogs;
      gettingData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    token = ref.read(stoken);
    var res = ref.read(suser);
    user = jsonDecode(res);
    getFutureData(context, token);
  }

  @override
  Widget build(BuildContext context) {
    return DiscoverPageScaffold(
      token: token,
      user: user,
      blogs: blogs,
      gettingData: gettingData,
    );
  }
}

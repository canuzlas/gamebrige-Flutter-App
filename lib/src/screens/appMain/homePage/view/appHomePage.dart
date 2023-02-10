import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/homePage/controller/homePageController.dart';
import 'package:gamebrige/src/screens/appMain/homePage/particals/homePageScaffold.dart';
import 'package:gamebrige/src/sm/sm_with_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  HomePageController homePageController = HomePageController();

  late var token;
  late var user;
  late var prefs;
  late var blogs = [];
  bool gettingData = true;

  getFutureData(context, token, user) async {
    var refprefs = await homePageController.getSharedPreferences();
    var refblogs =
        (await homePageController.getFollowedsBlogs(context, token, user))!;
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
    user = ref.read(suser);
    homePageController.getPermissions();
    homePageController.createMessageListenerForNotification(user);
    getFutureData(context, token, user);
  }

  @override
  Widget build(BuildContext context) {
    return HomePageScaffold(
      token: token,
      user: user,
      blogs: blogs,
      gettingData: gettingData,
    );
  }
}

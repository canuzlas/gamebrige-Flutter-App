import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appStartPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences prefs;
  late String token = "";

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token")!;
    setState(() {});
    //print(token);
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, ref, widget) {
          var title = ref.watch(deneme);
          return Text(title);
        }),
      ),
    );
  }
}

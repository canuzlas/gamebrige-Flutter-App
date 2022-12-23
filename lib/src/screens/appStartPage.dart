import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Map token = {};

  @override
  void initState() {
    super.initState();
    void getToken() async {
      var response = await http.get(Uri.parse("http://127.0.0.1:3000/api"));
      token = jsonDecode(response.body);
      print(token["token"]);
    }

    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/images/logo.png")),
    );
  }
}

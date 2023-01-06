import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterStepFourPage extends StatefulWidget {
  const RegisterStepFourPage({Key? key}) : super(key: key);

  @override
  State<RegisterStepFourPage> createState() => _RegisterStepFourPageState();
}

class _RegisterStepFourPageState extends State<RegisterStepFourPage> {
  late SharedPreferences prefs;

  void initAsyncStorage() async {
    prefs = await SharedPreferences.getInstance();
    print(prefs.getKeys());
    print(prefs.getString("willregmail"));
    print(prefs.getString("willregusername"));
    print(prefs.getString("token"));
  }

  @override
  void initState() {
    super.initState();
    initAsyncStorage();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

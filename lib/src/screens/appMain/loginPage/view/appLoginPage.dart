import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/loginPage/controller/loginPageController.dart';
import 'package:gamebrige/src/screens/appMain/loginPage/particals/loginPageScaffold.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  LoginPageController loginPageController = LoginPageController();
  late var prefs;

  getFutureData() async {
    var refPrefs = await loginPageController.getSharedPreferences();
    setState(() {
      prefs = refPrefs;
    });
  }

  @override
  void initState() {
    super.initState();
    getFutureData();
  }

  @override
  Widget build(BuildContext context) {
    return const LoginPageScaffold();
  }
}

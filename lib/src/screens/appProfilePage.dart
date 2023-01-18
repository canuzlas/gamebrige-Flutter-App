import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences prefs;

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    //print(prefs.getString("user"));
  }

  _logout() {
    prefs.remove("user");
    Navigator.pushNamed(context, "/Login");
  }

  @override
  void initState() {
    // TODO: implement initState
    getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("profile"),
      ),
      body: Center(
        child: OutlinedButton(
          child: Text("Çıkış"),
          onPressed: () {
            _logout();
          },
        ),
      ),
    );
  }
}

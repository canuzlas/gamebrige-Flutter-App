import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfilePageDrawerMenu extends StatefulWidget {
  final user;
  const MyProfilePageDrawerMenu({Key? key, this.user}) : super(key: key);

  @override
  State<MyProfilePageDrawerMenu> createState() =>
      _MyProfilePageDrawerMenuState();
}

class _MyProfilePageDrawerMenuState extends State<MyProfilePageDrawerMenu> {
  late var prefs;
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
    return Drawer(
      backgroundColor: Color.fromRGBO(203, 241, 245, 1),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(166, 227, 233, 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(
                    widget.user["photo"] == false
                        ? "assets/images/defaultpp.jpeg"
                        : "assets/images/defaultpp.jpeg",
                  ),
                ),
                Flexible(
                  child: Text(
                    widget.user["username"],
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Blog Paylaş'),
            onTap: () {
              Navigator.pushNamed(context, '/BlogShare');
            },
          ),
          ListTile(
            title: const Text('Profili Düzenle'),
            onTap: () {
              Fluttertoast.showToast(
                  msg: "Çok Yakında Aktif Edilecek!",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.transparent,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
          ListTile(
            title: const Text('Mesajlarım'),
            onTap: () {
              Navigator.pushNamed(context, '/AllMessages');
            },
          ),
          ListTile(
            title: const Text(
              "Çıkış Yap",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              prefs.remove("user");
              prefs.remove("fbuser");
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/Landing");
            },
          ),
        ],
      ),
    );
  }
}

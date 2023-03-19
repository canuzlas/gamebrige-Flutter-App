import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfilePageDrawerMenu extends StatefulWidget {
  final user;
  const MyProfilePageDrawerMenu({Key? key, this.user}) : super(key: key);

  @override
  State<MyProfilePageDrawerMenu> createState() =>
      _MyProfilePageDrawerMenuState();
}

class _MyProfilePageDrawerMenuState extends State<MyProfilePageDrawerMenu> {
  late SharedPreferences prefs;
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
      child: Column(
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
                    widget.user["photo"] == "false"
                        ? "assets/images/defaultpp.jpeg"
                        : "assets/images/${widget.user["photo"]}",
                  ),
                ),
                Flexible(
                  child: Text(
                    widget.user["username"],
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
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
              Navigator.pushNamed(context, '/EditProfile');
            },
          ),
          ListTile(
            title: const Text('Mesajlarım'),
            onTap: () {
              Navigator.pushNamed(context, '/AllMessages');
            },
          ),
          ListTile(
            title: const Text('Şifreni değiştir'),
            onTap: () {
              Navigator.pushNamed(context, '/ChangePassword');
            },
          ),
          ListTile(
            title: const Text(
              "Çıkış Yap",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await prefs.remove("user");
              await prefs.remove("fbuser");
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/Landing', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyProfilePageAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyProfilePageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: Border(bottom: BorderSide(color: Colors.white, width: 1)),
      elevation: 0.2,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/BlogShare');
          },
          icon: const Icon(Icons.add),
          color: Colors.black,
        ),
        Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            color: Colors.black,
            icon: const Icon(Icons.menu),
          );
        })
      ],
      backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: const Text(
        "GAMEBRIGE",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

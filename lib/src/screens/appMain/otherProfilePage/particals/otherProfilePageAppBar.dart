import 'package:flutter/material.dart';

import '../controller/otherProfilePageController.dart';

class OtherProfilePageAppBar extends StatefulWidget with PreferredSizeWidget {
  final token;
  final user;
  final person_id;
  const OtherProfilePageAppBar(
      {Key? key, this.token, this.user, this.person_id})
      : super(key: key);

  @override
  State<OtherProfilePageAppBar> createState() => _OtherProfilePageAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _OtherProfilePageAppBarState extends State<OtherProfilePageAppBar> {
  OtherProfilePageController otherProfilePageController =
      OtherProfilePageController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: Border(bottom: BorderSide(color: Colors.white, width: 1)),
      elevation: 0.2,
      actions: [
        PopupMenuButton(
            icon: const Icon(Icons.error_outline),
            color: Colors.red,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () {
                    otherProfilePageController.reportThisPerson(
                        context,
                        widget.token,
                        widget.person_id["user_id"],
                        widget.user["id"]);
                  },
                  child: const Text(
                    "Hesabı Şikayet Et",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ];
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
}

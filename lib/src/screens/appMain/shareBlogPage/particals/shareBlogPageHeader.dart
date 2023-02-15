import 'package:flutter/material.dart';

class ShareBlogPageHeader extends StatelessWidget {
  const ShareBlogPageHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white),
          ),
        ),
        child: Row(
          children: [
            const Text(
              "GAMEBRIGE",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/AllMessages');
              },
              icon: const Icon(Icons.message_outlined),
            ),
          ],
        ),
      ),
    );
  }
}

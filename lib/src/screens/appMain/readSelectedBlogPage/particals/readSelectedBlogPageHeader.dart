import 'package:flutter/material.dart';

class ReadSelectedBlogPageHeader extends StatelessWidget {
  const ReadSelectedBlogPageHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 0, top: 10, bottom: 10, right: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white),
          ),
        ),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            const Text(
              "GAMEBRIGE",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/BlogShare');
              },
              icon: const Icon(Icons.add),
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

import 'package:flutter/material.dart';

class DiscoverPageHeader extends StatelessWidget {
  const DiscoverPageHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(15),
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

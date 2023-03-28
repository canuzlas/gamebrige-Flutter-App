import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/passwordProceses/rememberPasswordPage/particals/rememberPasswordPageForms.dart';
import 'package:gamebrige/src/screens/passwordProceses/rememberPasswordPage/particals/rememberPasswordPageHeader.dart';

class RememberPasswordPageScaffold extends StatefulWidget {
  const RememberPasswordPageScaffold({Key? key}) : super(key: key);

  @override
  State<RememberPasswordPageScaffold> createState() =>
      _ChangePasswordPageScaffoldState();
}

class _ChangePasswordPageScaffoldState
    extends State<RememberPasswordPageScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
      body: Column(
        children: [
          const RememberPasswordPageHeader(),
          RememberPasswordPageForms(),
        ],
      ),
    );
  }
}

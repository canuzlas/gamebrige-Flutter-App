import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/passwordProceses/changePasswordPage/particals/changePasswordPageHeader.dart';

import 'changePasswordPageForms.dart';

class ChangePasswordPageScaffold extends StatefulWidget {
  const ChangePasswordPageScaffold({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPageScaffold> createState() =>
      _ChangePasswordPageScaffoldState();
}

class _ChangePasswordPageScaffoldState
    extends State<ChangePasswordPageScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
      body: Column(
        children: [
          const ChangePasswordPageHeader(),
          ChangePasswordPageForms(),
        ],
      ),
    );
  }
}

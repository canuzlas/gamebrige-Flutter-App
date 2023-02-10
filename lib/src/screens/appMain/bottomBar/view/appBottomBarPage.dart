import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appMain/bottomBar/particals/bottomBarScaffold.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomBarScaffold();
  }
}

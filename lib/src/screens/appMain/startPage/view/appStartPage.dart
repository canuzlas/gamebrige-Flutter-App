import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appMain/startPage/controller/startPageController.dart';
import 'package:gamebrige/src/screens/appMain/startPage/particals/startPageScaffold.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  StartPageController startPageController = StartPageController();

  @override
  void initState() {
    super.initState();
    startPageController.getPermissions();
    try {
      startPageController.getToken(context);
    } on Exception catch (exception) {
      startPageController.setTimeout(
          () => {Navigator.pushNamed(context, '/404')}, 2000);
    } catch (error) {
      startPageController.setTimeout(
          () => {Navigator.pushNamed(context, '/404')}, 2000);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const StartPageScaffold();
  }
}

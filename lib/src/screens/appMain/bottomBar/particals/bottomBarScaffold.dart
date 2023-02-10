import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appMain/bottomBar/controller/bottomBarController.dart';

class BottomBarScaffold extends StatefulWidget {
  const BottomBarScaffold({Key? key}) : super(key: key);

  @override
  State<BottomBarScaffold> createState() => _BottomBarScaffoldState();
}

class _BottomBarScaffoldState extends State<BottomBarScaffold> {
  late List<Widget> allPages;
  BottomBarController bottomBarController = BottomBarController();

  @override
  void initState() {
    super.initState();
    allPages = bottomBarController.getBottomBarPages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Anasayfa",
              backgroundColor: Color.fromRGBO(113, 201, 206, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: "Keşfet",
              backgroundColor: Color.fromRGBO(113, 201, 206, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.content_paste_search),
              label: "Kişi Ara",
              backgroundColor: Color.fromRGBO(113, 201, 206, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profil",
              backgroundColor: Color.fromRGBO(113, 201, 206, 1)),
        ],
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: bottomBarController.selectedIndex,
        onTap: (index) {
          setState(() {
            bottomBarController.selectedIndex = index;
          });
        },
      ),
      body: allPages[bottomBarController.selectedIndex],
    );
  }
}

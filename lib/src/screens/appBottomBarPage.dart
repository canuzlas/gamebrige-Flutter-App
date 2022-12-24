import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appBlogsPage.dart';
import 'package:gamebrige/src/screens/appHomePage.dart';
import 'package:gamebrige/src/screens/appSearchPage.dart';

import 'appProfilePage.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 0;
  late ProfilePage profilePage = const ProfilePage();
  late BlogsPage blogsPage = const BlogsPage();
  late HomePage homePage = const HomePage();
  late SearchPage searchPage = const SearchPage();
  late List<Widget> allPages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allPages = [homePage, blogsPage, searchPage, profilePage];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Anasayfa",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.comment),
              label: "Bloglar",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: "Ara",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profil",
              backgroundColor: Colors.white),
        ],
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black26,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      body: allPages[selectedIndex],
    );
  }
}

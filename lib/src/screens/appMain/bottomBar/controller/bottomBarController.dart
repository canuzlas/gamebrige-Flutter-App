import 'package:flutter/material.dart';

import '../../appSearchPage.dart';
import '../../discoverPage/view/appDiscoverPage.dart';
import '../../homePage/view/appHomePage.dart';
import '../../myProfilePage/view/appMyProfilePage.dart';

class BottomBarController {
  int selectedIndex = 0;
  ProfilePage profilePage = const ProfilePage();
  DiscoverPage blogsPage = const DiscoverPage();
  HomePage homePage = const HomePage();
  SearchPage searchPage = const SearchPage();

  List<Widget> getBottomBarPages() {
    List<Widget> allPages = [homePage, blogsPage, searchPage, profilePage];
    return allPages;
  }
}

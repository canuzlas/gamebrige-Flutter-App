import 'package:flutter/material.dart';

import '../../discoverPage/view/appDiscoverPage.dart';
import '../../homePage/view/appHomePage.dart';
import '../../myProfilePage/view/appMyProfilePage.dart';
import '../../searchPage/view/appSearchPage.dart';

class BottomBarController {
  int selectedIndex = 0;
  ProfilePage profilePage = ProfilePage();
  DiscoverPage blogsPage = DiscoverPage();
  HomePage homePage = HomePage();
  SearchPage searchPage = SearchPage();

  List<Widget> getBottomBarPages() {
    List<Widget> allPages = [homePage, blogsPage, searchPage, profilePage];
    return allPages;
  }
}

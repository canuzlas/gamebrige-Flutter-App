import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appMain/searchPage/particals/searchPageHeader.dart';
import 'package:gamebrige/src/screens/appMain/searchPage/particals/searchPageRecommendedUsersPart.dart';
import 'package:gamebrige/src/screens/appMain/searchPage/particals/searchPageSearchAndUsersPart.dart';

import '../controller/searchPageController.dart';

class SearchPageScaffold extends StatefulWidget {
  final token;
  final user;
  const SearchPageScaffold({Key? key, this.token, this.user}) : super(key: key);

  @override
  State<SearchPageScaffold> createState() => _SearchPageScaffoldState();
}

class _SearchPageScaffoldState extends State<SearchPageScaffold> {
  SearchPageController searchPageController = SearchPageController();

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
          body: Column(
            children: [
              //header
              const SearchPageHeader(),
              //search
              SearchPageSearchAndUsersPart(
                token: widget.token,
                user: widget.user,
              ),
              //recommended users
              SearchPageRecommendedUsersPart(
                token: widget.token,
                user: widget.user,
              )
            ],
          )),
    );
    ;
  }
}

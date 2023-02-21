import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/searchPage/particals/searchPageHeader.dart';
import 'package:gamebrige/src/screens/appMain/searchPage/particals/searchPageRecommendedUsersPart.dart';
import 'package:gamebrige/src/screens/appMain/searchPage/particals/searchPageSearchPart.dart';
import 'package:gamebrige/src/screens/appMain/searchPage/particals/searchPageUsersPart.dart';

import '../controller/searchPageController.dart';
import '../state/search_page_state.dart';

class SearchPageScaffold extends ConsumerStatefulWidget {
  final token;
  final user;
  final bestUsers;
  const SearchPageScaffold({Key? key, this.token, this.user, this.bestUsers})
      : super(key: key);

  @override
  ConsumerState<SearchPageScaffold> createState() => _SearchPageScaffoldState();
}

class _SearchPageScaffoldState extends ConsumerState<SearchPageScaffold> {
  SearchPageController searchPageController = SearchPageController();

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(searchUserNotiProvider.notifier).getUsers();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
          body: Column(
            children: [
              //header
              const SearchPageHeader(),
              //search
              SearchPageSearchPart(
                token: widget.token,
                user: widget.user,
              ),
              //search
              SearchPageUsersPart(
                token: widget.token,
                user: widget.user,
                users: users,
              ),
              //recommended users
              SearchPageRecommendedUsersPart(
                  token: widget.token,
                  user: widget.user,
                  bestUsers: widget.bestUsers)
            ],
          )),
    );
  }
}

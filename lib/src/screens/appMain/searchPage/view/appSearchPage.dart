import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/searchPage/controller/searchPageController.dart';
import 'package:gamebrige/src/sm/sm_with_riverpod.dart';

import '../particals/searchPageScaffold.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  SearchPageController searchPageController = SearchPageController();

  late var token;
  late var user;

  @override
  void initState() {
    super.initState();
    token = ref.read(stoken);
    var getuser = ref.read(suser);
    user = jsonDecode(getuser);
  }

  @override
  Widget build(BuildContext context) {
    return SearchPageScaffold(token: token, user: user);
  }
}

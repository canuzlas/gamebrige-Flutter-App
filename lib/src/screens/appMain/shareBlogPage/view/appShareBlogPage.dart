import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/shareBlogPage/controller/shareBlogPageController.dart';
import 'package:gamebrige/src/screens/appMain/shareBlogPage/particals/shareBlogPageScaffold.dart';
import 'package:gamebrige/src/sm/sm_with_riverpod.dart';

class BlogSharePage extends ConsumerStatefulWidget {
  const BlogSharePage({Key? key}) : super(key: key);

  @override
  ConsumerState<BlogSharePage> createState() => _BlogSharePageState();
}

class _BlogSharePageState extends ConsumerState<BlogSharePage> {
  ShareBlogController shareBlogController = ShareBlogController();
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
    return ShareBlogPageScaffold(
      token: token,
      user: user,
    );
  }
}

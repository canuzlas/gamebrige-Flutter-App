import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/readSelectedBlogPage/controller/readSelectedBlogPageController.dart';
import 'package:gamebrige/src/screens/appMain/readSelectedBlogPage/particals/readSelectedBlogPageScaffold.dart';
import 'package:gamebrige/src/sm/sm_with_riverpod.dart';

class ReadSelectedBlogPage extends ConsumerStatefulWidget {
  late var blogId;
  ReadSelectedBlogPage({Key? key, required this.blogId}) : super(key: key);

  @override
  ConsumerState<ReadSelectedBlogPage> createState() =>
      _ReadSelectedBlogPageState();
}

class _ReadSelectedBlogPageState extends ConsumerState<ReadSelectedBlogPage> {
  ReadSelectedBlogPageController readSelectedBlogPageController =
      ReadSelectedBlogPageController();
  late bool liked = false;
  late var blog = {};
  late var author = {};
  late var user;
  late var token;

  getFutureData() async {
    await readSelectedBlogPageController.getBlog(
        context, token, widget.blogId["blog_id"]);
    setState(() {
      author = readSelectedBlogPageController.author;
      blog = readSelectedBlogPageController.blog;
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.blogId["blog_id"]);
    token = ref.read(stoken);
    var res = ref.read(suser);
    user = jsonDecode(res);
    getFutureData();
  }

  @override
  Widget build(BuildContext context) {
    return ReadSelectedBlogPageScaffold(
      author: author,
      token: token,
      blog: blog,
      user: user,
      blogId: widget.blogId["blog_id"],
    );
  }
}

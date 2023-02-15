import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appMain/readSelectedBlogPage/particals/readSelectedBlogPageBlogPart.dart';
import 'package:gamebrige/src/screens/appMain/readSelectedBlogPage/particals/readSelectedBlogPageHeader.dart';

import '../controller/readSelectedBlogPageController.dart';

class ReadSelectedBlogPageScaffold extends StatefulWidget {
  final author;
  final blogId;
  final token;
  final user;
  final blog;
  const ReadSelectedBlogPageScaffold(
      {Key? key, this.author, this.blog, this.token, this.user, this.blogId})
      : super(key: key);

  @override
  State<ReadSelectedBlogPageScaffold> createState() =>
      _ReadSelectedBlogPageScaffoldState();
}

class _ReadSelectedBlogPageScaffoldState
    extends State<ReadSelectedBlogPageScaffold> {
  ReadSelectedBlogPageController readSelectedBlogPageController =
      ReadSelectedBlogPageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
      body: Column(
        children: [
          //header
          ReadSelectedBlogPageHeader(),
          //blog
          ReadSelectedBlogPageBlogPart(
            author: widget.author,
            blogId: widget.blogId,
            token: widget.token,
            user: widget.user,
            blog: widget.blog,
          )
        ],
      ),
    );
  }
}

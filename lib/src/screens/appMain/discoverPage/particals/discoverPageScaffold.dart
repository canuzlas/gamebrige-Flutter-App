import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appMain/discoverPage/particals/discoverPageBlogs.dart';
import 'package:gamebrige/src/screens/appMain/discoverPage/particals/discoverPageHeader.dart';
import 'package:gamebrige/src/screens/appMain/discoverPage/particals/discoverPageTopFont.dart';

class DiscoverPageScaffold extends StatefulWidget {
  final token;
  final user;
  final blogs;

  const DiscoverPageScaffold({
    Key? key,
    this.token,
    this.user,
    this.blogs,
  }) : super(key: key);

  @override
  State<DiscoverPageScaffold> createState() => _DiscoverPageScaffoldState();
}

class _DiscoverPageScaffoldState extends State<DiscoverPageScaffold> {
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
              const DiscoverPageHeader(),
              //blogs
              widget.blogs.isEmpty
                  ? Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Image.asset(
                              "assets/images/notfound.gif",
                              height: 150.0,
                              width: 150.0,
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                              "Uygulama henüz yeni ilk bloğu sen paylaş !"),
                        ),
                      ],
                    )
                  :
                  //top font
                  const DiscoverPageTopFont(),
              DiscoverPageBlogs(
                token: widget.token,
                user: widget.user,
                blogs: widget.blogs,
              )
            ],
          )),
    );
  }
}

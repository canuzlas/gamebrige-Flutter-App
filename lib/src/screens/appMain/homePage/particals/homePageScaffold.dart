import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appMain/homePage/controller/homePageController.dart';
import 'package:gamebrige/src/screens/appMain/homePage/particals/homePageBlogs.dart';
import 'package:gamebrige/src/screens/appMain/homePage/particals/homePageBodyTopFont.dart';
import 'package:gamebrige/src/screens/appMain/homePage/particals/homePageHeader.dart';

class HomePageScaffold extends StatefulWidget {
  final token;
  final user;
  final blogs;
  final gettingData;

  HomePageScaffold(
      {Key? key, this.token, this.user, this.blogs, this.gettingData})
      : super(key: key);

  @override
  State<HomePageScaffold> createState() => _HomePageScaffoldState();
}

class _HomePageScaffoldState extends State<HomePageScaffold> {
  HomePageController homePageController = HomePageController();

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              const HomePageHeader(),
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
                          child: Text("Keşfet kısmına göz atmalısın"),
                        ),
                      ],
                    )
                  :
                  //top font
                  const HomePageTopFont(),
              HomePageBlogs(
                  user: widget.user, token: widget.token, blogs: widget.blogs)
            ],
          )),
    );
  }
}

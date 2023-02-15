import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appMain/homePage/controller/homePageController.dart';
import 'package:gamebrige/src/screens/appMain/homePage/particals/homePageBlogs.dart';
import 'package:gamebrige/src/screens/appMain/homePage/particals/homePageBodyTopFont.dart';
import 'package:gamebrige/src/screens/appMain/homePage/particals/homePageHeader.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
              HomePageHeader(),
              //top font
              HomePageTopFont(),
              //blogs

              widget.gettingData
                  ? Container(
                      height: 300,
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 100,
                      ),
                    )
                  : widget.blogs.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "Görüntülenecek blog bulunamadı. Lütfen keşfet kısmına göz at.",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        )
                      : HomePageBlogs(
                          user: widget.user,
                          token: widget.token,
                          blogs: widget.blogs)
            ],
          )),
    );
  }
}

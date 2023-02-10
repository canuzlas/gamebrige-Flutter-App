import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appMain/discoverPage/particals/discoverPageBlogs.dart';
import 'package:gamebrige/src/screens/appMain/discoverPage/particals/discoverPageHeader.dart';
import 'package:gamebrige/src/screens/appMain/discoverPage/particals/discoverPageTopFont.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DiscoverPageScaffold extends StatefulWidget {
  final token;
  final user;
  final prefs;
  final blogs;
  final gettingData;

  const DiscoverPageScaffold(
      {Key? key,
      this.token,
      this.user,
      this.prefs,
      this.blogs,
      this.gettingData})
      : super(key: key);

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
              DiscoverPageHeader(),
              //top font
              DiscoverPageTopFont(),
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
                      : DiscoverPageBlogs(
                          token: widget.token,
                          user: widget.user,
                          prefs: widget.prefs,
                          blogs: widget.blogs,
                          gettingData: widget.gettingData,
                        )
            ],
          )),
    );
  }
}

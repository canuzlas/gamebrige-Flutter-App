import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamebrige/src/screens/appMain/shareBlogPage/particals/shareBlogPageHeader.dart';

import '../controller/shareBlogPageController.dart';

class ShareBlogPageScaffold extends StatefulWidget {
  final token;
  final user;
  const ShareBlogPageScaffold({Key? key, this.token, this.user})
      : super(key: key);
  @override
  State<ShareBlogPageScaffold> createState() => _ShareBlogPageScaffoldState();
}

class _ShareBlogPageScaffoldState extends State<ShareBlogPageScaffold> {
  ShareBlogController shareBlogController = ShareBlogController();
  ConfettiController confettiController = ConfettiController();
  late String title = "";
  late String text = "";
  late bool keyboard = false;
  bool _keyboardVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
        body: Column(
          children: [
            ConfettiWidget(
              confettiController: confettiController,
              emissionFrequency: 0.02,
              numberOfParticles: 10,
              maxBlastForce: 20,
              minBlastForce: 5,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: pi,
              gravity: 0.2,
              shouldLoop: false,
              displayTarget: false,
              colors: null,
              minimumSize: const Size(20, 10),
              maximumSize: const Size(30, 15),
              particleDrag: 0.05,
              canvas: MediaQuery.of(context).size,
              child: null,
            ),
            //header
            const ShareBlogPageHeader(),
            //form
            Flexible(
              child: Container(
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.only(
                      bottom: 20, left: 10, right: 10, top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromRGBO(203, 241, 245, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      //title
                      Container(
                        margin: EdgeInsets.only(top: 0),
                        //margin: const EdgeInsets.only(top: 120),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Form(
                              child: TextField(
                                maxLength: 60,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelText: 'Blog Başlığı',
                                ),
                                style: TextStyle(color: Colors.black),
                                onChanged: (txt) {
                                  setState(() {
                                    title = txt;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      //text
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 0),
                          //margin: const EdgeInsets.only(top: 120),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Form(
                                child: SingleChildScrollView(
                                  child: TextField(
                                    maxLength: 10000,
                                    maxLines: _keyboardVisible ? 13 : 13,
                                    decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelText: 'Blog içeriğiniz',
                                    ),
                                    style: TextStyle(color: Colors.black),
                                    onChanged: (txt) {
                                      setState(() {
                                        text = txt;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      //send button
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.all(10),
                        child: OutlinedButton(
                          onPressed: () {
                            title.isEmpty || text.isEmpty
                                ? Fluttertoast.showToast(
                                    msg:
                                        "başlık veya içerik kısmı boş bırakılamaz.!",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.transparent,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                                : shareBlogController.shareBlog(context,
                                    widget.token, widget.user, title, text);
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent),
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.all(8.0)),
                              elevation: MaterialStatePropertyAll(1.0),
                              side: MaterialStatePropertyAll(
                                  BorderSide(width: 1.0, color: Colors.white))),
                          child: const Text(
                            "Blog Paylaş",
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ));
    ;
  }
}

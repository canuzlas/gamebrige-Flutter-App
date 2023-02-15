import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controller/readSelectedBlogPageController.dart';

class ReadSelectedBlogPageBlogPart extends StatefulWidget {
  final author;
  final blogId;
  final token;
  final user;
  final blog;
  const ReadSelectedBlogPageBlogPart(
      {Key? key, this.author, this.blogId, this.token, this.user, this.blog})
      : super(key: key);

  @override
  State<ReadSelectedBlogPageBlogPart> createState() =>
      _ReadSelectedBlogPageBlogPartState();
}

class _ReadSelectedBlogPageBlogPartState
    extends State<ReadSelectedBlogPageBlogPart> {
  ReadSelectedBlogPageController readSelectedBlogPageController =
      ReadSelectedBlogPageController();
  bool liked = false;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(bottom: 50, left: 10, right: 10, top: 20),
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromRGBO(203, 241, 245, 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            //author
            widget.author.isEmpty
                ? Flexible(
                    child: Container(
                      height: 300,
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromRGBO(203, 241, 245, 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ]),
                    child: GestureDetector(
                      onTap: () {
                        widget.author["_id"] != widget.user["_id"]
                            ? Navigator.pushNamed(
                                context,
                                "/OtherProfile",
                                arguments: {"user_id": widget.author["_id"]},
                              )
                            : null;
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: AssetImage(
                                widget.author["photo"] == false
                                    ? "assets/images/defaultpp.jpeg"
                                    : "assets/images/defaultpp.jpeg",
                              ),
                            ),
                          ),
                          Text(
                            widget.author["username"],
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          PopupMenuButton(
                              icon: const Icon(Icons.accessibility),
                              color: const Color.fromRGBO(113, 201, 206, 1),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    onTap: () {
                                      readSelectedBlogPageController
                                          .reportThisBlog(context, widget.token,
                                              widget.user, widget.blog["_id"]);
                                    },
                                    child: const Text(
                                      "Bloğu Şikayet Et",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ];
                              }),
                        ],
                      ),
                    ),
                  ),
            //data
            widget.blog.isEmpty
                ? Flexible(
                    child: Container(
                      height: 300,
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  )
                : Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      widget.blog["blog_title"],
                      softWrap: true,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
            !widget.blog.isEmpty
                ? Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Text(widget.blog["blog_text"]),
                    ),
                  )
                : Text(""),

            Container(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    liked = !liked;
                  });
                },
                icon: liked
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(Icons.favorite_border),
              ),
            )
          ],
        ),
      ),
    );
  }
}

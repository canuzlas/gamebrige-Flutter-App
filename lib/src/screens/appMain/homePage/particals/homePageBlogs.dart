import 'package:flutter/material.dart';

import '../controller/homePageController.dart';

class HomePageBlogs extends StatefulWidget {
  final token;
  final user;
  final blogs;

  const HomePageBlogs({Key? key, this.token, this.user, this.blogs})
      : super(key: key);

  @override
  State<HomePageBlogs> createState() => _HomePageBlogsState();
}

class _HomePageBlogsState extends State<HomePageBlogs> {
  HomePageController homePageController = HomePageController();
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: RefreshIndicator(
        onRefresh: () async {
          homePageController.getFollowedsBlogs(
              context, widget.token, widget.user);
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: widget.blogs.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/ReadSelectedBlog",
                    arguments: {"blog_id": widget.blogs[i]["_id"]});
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(15),
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromRGBO(203, 241, 245, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 100),
                      child: Image.asset(
                        "assets/images/startpage-bg.jpeg",
                        fit: BoxFit.fill,
                        width: 100,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 0,
                            ),
                            child: Text(
                              "${widget.blogs[i]["blog_title"]}",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 4,
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: GestureDetector(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(right: 5, left: 8),
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundImage: AssetImage(
                                            widget.blogs[i]
                                                        ["blog_author_photo"] ==
                                                    false
                                                ? "assets/images/defaultpp.jpeg"
                                                : "assets/images/defaultpp.jpeg",
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          widget.blogs[i]
                                                  ["blog_author_username"]
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/OtherProfile",
                                      arguments: {
                                        "user_id": widget.blogs[i]
                                            ["blog_author"]
                                      },
                                    );
                                  },
                                ),
                              ),
                              Text(
                                "${widget.blogs[i]["createdAt"].substring(0, 10)}",
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

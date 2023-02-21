import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/discoverPage/state/discover_page_state.dart';

import '../controller/discoverPageController.dart';

class DiscoverPageBlogs extends ConsumerStatefulWidget {
  final token;
  final user;
  final blogs;
  const DiscoverPageBlogs({
    Key? key,
    this.token,
    this.user,
    this.blogs,
  }) : super(key: key);

  @override
  ConsumerState<DiscoverPageBlogs> createState() => _DiscoverPageBlogsState();
}

class _DiscoverPageBlogsState extends ConsumerState<DiscoverPageBlogs> {
  DiscoverPageController discoverPageController = DiscoverPageController();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(discoverPageFutureProvider);
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundImage: AssetImage(
                                              widget.blogs[i][
                                                          "blog_author_photo"] ==
                                                      false
                                                  ? "assets/images/defaultpp.jpeg"
                                                  : "assets/images/defaultpp.jpeg",
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            widget.blogs[i]
                                                ["blog_author_username"],
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    widget.blogs[i]["blog_author"] !=
                                            jsonDecode(widget.user)["_id"]
                                        ? Navigator.pushNamed(
                                            context,
                                            "/OtherProfile",
                                            arguments: {
                                              "user_id": widget.blogs[i]
                                                  ["blog_author"]
                                            },
                                          )
                                        : null;
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

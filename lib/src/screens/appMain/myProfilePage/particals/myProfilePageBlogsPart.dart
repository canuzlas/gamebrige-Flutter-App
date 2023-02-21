import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/myProfilePageController.dart';

class MyProfilePageBlogsPart extends ConsumerStatefulWidget {
  final token;
  final user;
  final blogs;
  const MyProfilePageBlogsPart({Key? key, this.token, this.user, this.blogs})
      : super(key: key);

  @override
  ConsumerState<MyProfilePageBlogsPart> createState() =>
      _MyProfilePageBlogsPartState();
}

class _MyProfilePageBlogsPartState
    extends ConsumerState<MyProfilePageBlogsPart> {
  MyProfilePageController myProfilePageController = MyProfilePageController();

  @override
  Widget build(BuildContext context) {
    return (widget.blogs.isEmpty)
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Hiç gönderin yok.",
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
        : Flexible(
            child: RefreshIndicator(
              onRefresh: () async {},
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topCenter,
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    top: 10,
                                  ),
                                  child: Text(
                                    "${widget.blogs[i]["blog_text"]}",
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 4,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton(
                              icon: const Icon(Icons.settings),
                              onSelected: (result) {
                                result == 0
                                    ? Navigator.pushNamed(
                                        context, '/UpdateBlog',
                                        arguments: widget.blogs[i])
                                    : null;
                              },
                              color: const Color.fromRGBO(113, 201, 206, 1),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    onTap: () {
                                      myProfilePageController.deleteBlog(
                                          context,
                                          widget.blogs[i]["_id"],
                                          widget.blogs[i],
                                          widget.token);
                                      setState(() {
                                        widget.blogs.remove(widget.blogs[i]);
                                      });
                                    },
                                    child: const Text(
                                      "Bloğu Sil",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 0,
                                    child: Text(
                                      "Bloğu Düzenle",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ];
                              })
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

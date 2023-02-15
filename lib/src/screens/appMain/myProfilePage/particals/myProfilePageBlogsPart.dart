import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controller/myProfilePageController.dart';

class MyProfilePageBlogsPart extends StatefulWidget {
  final token;
  final user;
  const MyProfilePageBlogsPart({Key? key, this.token, this.user})
      : super(key: key);

  @override
  State<MyProfilePageBlogsPart> createState() => _MyProfilePageBlogsPartState();
}

class _MyProfilePageBlogsPartState extends State<MyProfilePageBlogsPart> {
  MyProfilePageController myProfilePageController = MyProfilePageController();

  bool gettingData = true;
  var blogs = [];

  getFutureData(context) async {
    var refBlogs = await myProfilePageController.getMyBlogs(
        context, widget.token, widget.user["_id"]);
    setState(() {
      blogs = refBlogs;
      gettingData = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFutureData(context);
  }

  @override
  Widget build(BuildContext context) {
    return (blogs.isEmpty && gettingData == false)
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Hiç gönderin yok.",
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
        : gettingData
            ? Container(
                height: 300,
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 100,
                ),
              )
            : Flexible(
                child: RefreshIndicator(
                  onRefresh: () async {
                    getFutureData(context);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: blogs.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/ReadSelectedBlog",
                              arguments: {"blog_id": blogs[i]["_id"]});
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
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
                                        "${blogs[i]["blog_title"]}",
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
                                        "${blogs[i]["blog_text"]}",
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
                                        ? myProfilePageController.updateBlog(
                                            context, i)
                                        : null;
                                  },
                                  color: const Color.fromRGBO(113, 201, 206, 1),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        onTap: () {
                                          myProfilePageController.deleteBlog(
                                              context,
                                              blogs[i]["_id"],
                                              blogs[i],
                                              widget.token);
                                          setState(() {
                                            blogs.remove(blogs[i]);
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

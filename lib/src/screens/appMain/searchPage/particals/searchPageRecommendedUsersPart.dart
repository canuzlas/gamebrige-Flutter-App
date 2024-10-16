import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/searchPageController.dart';

class SearchPageRecommendedUsersPart extends ConsumerStatefulWidget {
  final token;
  final user;
  final bestUsers;
  const SearchPageRecommendedUsersPart(
      {Key? key, this.token, this.user, this.bestUsers})
      : super(key: key);

  @override
  ConsumerState<SearchPageRecommendedUsersPart> createState() =>
      _SearchPageRecommendedUsersPartState();
}

class _SearchPageRecommendedUsersPartState
    extends ConsumerState<SearchPageRecommendedUsersPart> {
  SearchPageController searchPageController = SearchPageController();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          const Text(
            "Önerilen Kullanıcılar",
            style: TextStyle(fontSize: 20),
          ),
          Flexible(
            child: SizedBox(
              width: 300,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: widget.bestUsers.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/OtherProfile",
                          arguments: {"user_id": widget.bestUsers[i]["_id"]});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromRGBO(203, 241, 245, 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                widget.bestUsers[i]["photo"] == "false"
                                    ? "assets/images/defaultpp.jpeg"
                                    : "assets/images/${widget.bestUsers[i]["photo"]}",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              widget.bestUsers[i]["username"],
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

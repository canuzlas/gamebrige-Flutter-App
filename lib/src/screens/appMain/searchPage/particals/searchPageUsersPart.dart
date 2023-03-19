import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPageUsersPart extends ConsumerStatefulWidget {
  final token;
  final user;
  final users;

  const SearchPageUsersPart({
    Key? key,
    this.users,
    this.token,
    this.user,
  }) : super(key: key);

  @override
  ConsumerState<SearchPageUsersPart> createState() =>
      _SearchPageUsersPartState();
}

class _SearchPageUsersPartState extends ConsumerState<SearchPageUsersPart> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          //users
          Flexible(
            child: Container(
              width: 300,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: widget.users.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      print(widget.users[i]["_id"]);
                      Navigator.pushNamed(context, "/OtherProfile",
                          arguments: {"user_id": widget.users[i]["_id"]});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(15),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                widget.users[i]["photo"] == "false"
                                    ? "assets/images/defaultpp.jpeg"
                                    : "assets/images/${widget.users[i]["photo"]}",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              widget.users[i]["username"],
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          //follow button
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

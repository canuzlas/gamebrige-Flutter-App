import 'package:flutter/material.dart';

import '../controller/searchPageController.dart';

class SearchPageSearchAndUsersPart extends StatefulWidget {
  final token;
  final user;
  const SearchPageSearchAndUsersPart({
    Key? key,
    this.token,
    this.user,
  }) : super(key: key);

  @override
  State<SearchPageSearchAndUsersPart> createState() =>
      _SearchPageSearchAndUsersPartState();
}

class _SearchPageSearchAndUsersPartState
    extends State<SearchPageSearchAndUsersPart> {
  var users = [];
  SearchPageController searchPageController = SearchPageController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          //search
          Container(
            margin: EdgeInsets.only(top: 0),
            width: 300,
            //margin: const EdgeInsets.only(top: 120),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  child: TextFormField(
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
                      labelText: 'Bir kullanıcı ara',
                    ),
                    style: TextStyle(color: Colors.black),
                    onChanged: (txt) async {
                      var refUsers;
                      txt.isEmpty
                          ? refUsers = []
                          : refUsers = await searchPageController.searchUser(
                              context, widget.token, widget.user["_id"], txt);
                      setState(() {
                        users = refUsers;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          //users
          Flexible(
            child: Container(
              width: 300,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: users.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/OtherProfile",
                          arguments: {"user_id": users[i]["_id"]});
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                users[i]["photo"] == false
                                    ? "assets/images/defaultpp.jpeg"
                                    : "assets/images/defaultpp.jpeg",
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              users[i]["username"],
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          //follow button
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: OutlinedButton(
                              onPressed: () {
                                searchPageController.followPerson(
                                    context,
                                    widget.token,
                                    widget.user["_id"],
                                    users[i]["_id"]);
                              },
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.transparent),
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.all(8.0)),
                                  elevation: MaterialStatePropertyAll(1.0),
                                  side: MaterialStatePropertyAll(BorderSide(
                                      width: 1.0, color: Colors.white))),
                              child: const Text(
                                "Takip Et",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
                            ),
                          )
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

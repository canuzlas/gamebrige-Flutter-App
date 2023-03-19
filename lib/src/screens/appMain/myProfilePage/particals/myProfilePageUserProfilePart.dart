import 'package:flutter/material.dart';

class MyProfilePageUserProfilePart extends StatefulWidget {
  final user;
  final blogs;
  const MyProfilePageUserProfilePart({Key? key, this.user, this.blogs})
      : super(key: key);

  @override
  State<MyProfilePageUserProfilePart> createState() =>
      _MyProfilePageUserProfilePartState();
}

class _MyProfilePageUserProfilePartState
    extends State<MyProfilePageUserProfilePart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //fotoğraf cart curt
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage(
                  widget.user["photo"] == "false"
                      ? "assets/images/defaultpp.jpeg"
                      : "assets/images/${widget.user["photo"]}",
                ),
              ),
              Column(
                children: [
                  Text(
                    widget.blogs.length.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text("Gönderi",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              Column(
                children: [
                  Text(widget.user["followers"].length.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Takipçi", style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              Column(
                children: [
                  Text((widget.user["following"].length).toString(),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Takip", style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            ],
          ),
        ),
        //kullanıcıadı
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            widget.user["username"],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        //katılma tarihi
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 0),
          child: Text(
            "Katılma tarihi: ${widget.user["createdAt"].substring(0, 10)}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        //profil düzenle blog paylaş
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(20),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/EditProfile');
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromRGBO(203, 241, 245, 1)),
                    padding: MaterialStatePropertyAll(EdgeInsets.all(5.0)),
                    elevation: MaterialStatePropertyAll(1.0),
                    side: MaterialStatePropertyAll(
                        BorderSide(width: 1.0, color: Colors.white))),
                child: const Text(
                  "Profili Düzenle",
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(20),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/BlogShare');
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromRGBO(203, 241, 245, 1)),
                    padding: MaterialStatePropertyAll(EdgeInsets.all(5.0)),
                    elevation: MaterialStatePropertyAll(1.0),
                    side: MaterialStatePropertyAll(
                        BorderSide(width: 1.0, color: Colors.white))),
                child: const Text(
                  "Blog Paylaş",
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

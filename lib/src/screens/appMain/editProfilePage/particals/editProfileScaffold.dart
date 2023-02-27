import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/editProfilePage/controller/editProfilePageController.dart';
import 'package:gamebrige/src/screens/appMain/editProfilePage/state/editProfilePage_state.dart';

class EditProfileScaffold extends ConsumerStatefulWidget {
  final user;
  final token;
  const EditProfileScaffold({Key? key, this.user, this.token})
      : super(key: key);

  @override
  ConsumerState<EditProfileScaffold> createState() =>
      _EditProfileScaffoldState();
}

class _EditProfileScaffoldState extends ConsumerState<EditProfileScaffold> {
  EditProfilePageController editProfilePageController =
      EditProfilePageController();
  late String name = widget.user["name"];
  late String username = widget.user["username"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
        body: Column(
          children: [
            //header
            SafeArea(
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    Text(
                      "${widget.user["username"]} (sen)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            //pp
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage(
                  widget.user["photo"] == false
                      ? "assets/images/defaultpp.jpeg"
                      : "assets/images/defaultpp.jpeg",
                ),
              ),
            ),
            //pp change button
            GestureDetector(
              onTap: () {},
              child: const Text(
                "Resmi değiştir",
                style: TextStyle(color: Colors.black87),
              ),
            ),
            //forms
            // name
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 15.0, left: 15.0, top: 10.0, bottom: 10.0),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  child: TextFormField(
                    validator: editProfilePageController.validateName,
                    initialValue: widget.user["name"],
                    maxLength: 25,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'Adın',
                    ),
                    style: TextStyle(color: Colors.black),
                    onChanged: (txt) {
                      setState(() {
                        name = txt;
                      });
                    },
                  ),
                ),
              ),
            ),
            //username
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                ),
                child: Form(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    validator: editProfilePageController.validateUsername,
                    initialValue: widget.user["username"],
                    maxLength: 18,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'Kullanıcı adın',
                    ),
                    style: TextStyle(color: Colors.black),
                    onChanged: (txt) {
                      setState(() {
                        username = txt;
                      });
                    },
                  ),
                ),
              ),
            ),
            //save
            Flexible(
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 50),
                child: OutlinedButton(
                  onPressed: () async {
                    var data = await editProfilePageController.updateProfile(
                        name, username, widget.user);
                    if (data) {
                      ref.refresh(userFutureProvider);
                    }
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.transparent),
                      padding: MaterialStatePropertyAll(EdgeInsets.all(11.0)),
                      elevation: MaterialStatePropertyAll(10.0),
                      side: MaterialStatePropertyAll(
                          BorderSide(width: 1.0, color: Colors.white))),
                  child: const Text(
                    "Devam Et",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

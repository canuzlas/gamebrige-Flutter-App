import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterStepThreePage extends StatefulWidget {
  const RegisterStepThreePage({Key? key}) : super(key: key);

  @override
  State<RegisterStepThreePage> createState() => _RegisterStepThreePageState();
}

class _RegisterStepThreePageState extends State<RegisterStepThreePage> {
  late SharedPreferences prefs;
  late String username;
  late bool possibleCont;

  String? validateUsername(String? value) {
    String pattern = r'^[A-Za-z][A-Za-z0-9_]{6,18}$';
    final regex = RegExp(pattern);
    if (value!.isNotEmpty && !regex.hasMatch(value)) {
      return 'Kullanıcı adınız minimum 6 maximum 18 karakter olabilir\nYalnızca "_" özel işaret kullanılabilir\nYalnızca küçük büyük harf ve rakam kullanabilirsin\nKullanıcı adınız harf ile başlamalı';
    } else {
      value!.isEmpty ? possibleCont = false : possibleCont = true;
      return null;
    }
  }

  goToStepFour() async {
    await prefs.setString("willregusername", username);
    Navigator.pushNamed(context, "/RegisterStep4");
  }

  void initAsyncStorage() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initAsyncStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //bg image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/register.jpeg"),
                  fit: BoxFit.cover),
            ),
          ),
          //top text
          Container(
            margin: EdgeInsets.only(bottom: 200),
            child: const Center(
              child: Text(
                "Kullanıcı adın ne olsun?",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white60),
              ),
            ),
          ),
          //input for username
          Container(
            margin: EdgeInsets.only(top: 10),
            //margin: const EdgeInsets.only(top: 120),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  child: TextFormField(
                    validator: validateUsername,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelText: 'Kullanıcı adı',
                    ),
                    style: TextStyle(color: Colors.white),
                    onChanged: (txt) {
                      setState(() {
                        username = txt;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          // continue button
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 50),
            child: OutlinedButton(
              onPressed: () {
                possibleCont == true
                    ? goToStepFour()
                    : username.length == 0
                        ? Fluttertoast.showToast(
                            msg: "Boş bırakılamaz.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.transparent,
                            textColor: Colors.white,
                            fontSize: 16.0)
                        : null;
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.transparent),
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
        ],
      ),
    );
  }
}

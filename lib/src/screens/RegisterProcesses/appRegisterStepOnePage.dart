import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../smtp/smtp.dart';

class RegisterStepOnePage extends StatefulWidget {
  const RegisterStepOnePage({Key? key}) : super(key: key);

  @override
  State<RegisterStepOnePage> createState() => _RegisterStepOnePageState();
}

class _RegisterStepOnePageState extends State<RegisterStepOnePage> {
  //generated otp code
  int code = Random().nextInt(999999);
  late SharedPreferences prefs;

  String email = "";
  bool possibleCont = false;
  //email regex
  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    if (value!.isNotEmpty && !regex.hasMatch(value)) {
      return 'Geçerli bir mail adresi gir';
    } else {
      value!.isEmpty ? possibleCont = false : possibleCont = true;
      return null;
    }
  }

  void sendOtpCode() async {
    Fluttertoast.showToast(
        msg: "Mail gönderiliyor..",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.transparent,
        textColor: Colors.white,
        fontSize: 16.0);
    bool res = await SMTP(code, email);
    if (res == true) {
      prefs.setInt("otpcode", code);
      Navigator.pushNamed(context, "/RegisterStep2");
    } else {
      Fluttertoast.showToast(
          msg: "Hata oldu, sonra tekrar dene.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.transparent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void initAsyncStorage() async {
    prefs = await SharedPreferences.getInstance();
    print(prefs.getInt("otpcode"));
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
          //bg photo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/register.jpeg"),
                  fit: BoxFit.cover),
            ),
          ),
          //top size font
          Container(
            margin: EdgeInsets.only(bottom: 200),
            child: const Center(
              child: Text(
                "GAMEBRİGE ailesine katılmaya hazırsın.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white60),
              ),
            ),
          ),
          //eposta input
          Container(
            margin: EdgeInsets.only(top: 10),
            //margin: const EdgeInsets.only(top: 120),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  child: TextFormField(
                    validator: validateEmail,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelText: 'E-posta adresin',
                    ),
                    style: TextStyle(color: Colors.white),
                    onChanged: (txt) {
                      setState(() {
                        email = txt;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          //devam buton
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 50),
            child: OutlinedButton(
              onPressed: () {
                possibleCont == true
                    ? sendOtpCode()
                    : email.length == 0
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

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterStepTwoPage extends StatefulWidget {
  const RegisterStepTwoPage({Key? key}) : super(key: key);

  @override
  State<RegisterStepTwoPage> createState() => _RegisterStepTwoPageState();
}

class _RegisterStepTwoPageState extends State<RegisterStepTwoPage> {
  late SharedPreferences prefs;
  Future<bool> _onWillPop() async {
    return false;
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

  void checkOtp(String v) {
    if (v == prefs.getInt("otpcode").toString()) {
      Navigator.pushNamed(context, "/RegisterStep3");
    } else {
      Fluttertoast.showToast(
          msg: "Kod Hatalı.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.transparent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/register.jpeg"),
                  fit: BoxFit.cover),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 250),
            child: const Center(
              child: Text(
                "E-posta adresine gelen kodu gir.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white60),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 13),
            child: Center(
              child: PinCodeTextField(
                length: 6,
                obscureText: false,
                animationType: AnimationType.scale,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  activeColor: Colors.greenAccent,
                  inactiveColor: Colors.pinkAccent,
                  disabledColor: Colors.transparent,
                  selectedFillColor: Colors.transparent,
                  inactiveFillColor: Colors.white10,
                  activeFillColor: Colors.transparent,

                  shape: PinCodeFieldShape.underline,
                  //borderRadius: BorderRadius.circular(5),
                  fieldHeight: 60,
                  fieldWidth: 40,
                ),
                textStyle: TextStyle(color: Colors.white),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                //errorAnimationController: errorController,
                //controller: textEditingController,
                onCompleted: (v) {
                  checkOtp(v);
                },
                appContext: context, onChanged: (String value) {},
              ),
            ),
          ),
        ],
      )),
    );
  }
}

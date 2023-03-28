import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamebrige/src/screens/passwordProceses/changePasswordPage/state/changePassword_page_state.dart';
import 'package:gamebrige/src/screens/passwordProceses/rememberPasswordPage/controller/rememberPasswordPageController.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RememberPasswordPageForms extends ConsumerWidget {
  RememberPasswordPageForms({super.key});

  RememberPasswordPageController rememberPasswordPageController =
      RememberPasswordPageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flexible(
      child: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 15, bottom: 20, left: 10, right: 10),
            child: const Center(
              child: Text(
                "E-posta adresine gelen kodu gir. Şifreni güncelledikten sonra mailene gelen linkten firebase şifreni güncelle. Aynı şifre olmasına dikkat et.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 13),
            child: Center(
              child: PinCodeTextField(
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  activeColor: Colors.brown,
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
                  rememberPasswordPageController.checkOtp(v);
                },
                appContext: context, onChanged: (String value) {},
              ),
            ),
          ),
          //top text
          const Padding(
            padding: EdgeInsets.only(top: 45.0),
            child: Center(
              child: Text(
                "Yeni bir şifre oluştur.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black87),
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //input for pass
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        autovalidateMode: AutovalidateMode.always,
                        child: TextFormField(
                          validator: ref
                              .read(changePasswordProvider.notifier)
                              .validate,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Yeni şifre',
                          ),
                          style: const TextStyle(color: Colors.black),
                          onChanged: (txt) {
                            ref
                                .read(changePasswordProvider.notifier)
                                .statePass(txt);
                          },
                        ),
                      ),
                    ),
                  ),
                  //input for repass
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Şifre tekrarı',
                          ),
                          style: TextStyle(color: Colors.black),
                          onChanged: (txt) {
                            ref
                                .read(changePasswordProvider.notifier)
                                .stateRepass(txt);
                          },
                        ),
                      ),
                    ),
                  ),
                  // continue button
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(bottom: 50),
                    child: OutlinedButton(
                      onPressed: () async {
                        final res =
                            ref.read(changePasswordProvider.notifier).doCheck();
                        res == "empty"
                            ? Fluttertoast.showToast(
                                msg: "Şifre boş bırakılamaz",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.transparent,
                                textColor: Colors.white,
                                fontSize: 16.0)
                            : res == "notvalid"
                                ? Fluttertoast.showToast(
                                    msg: "Şifreniz uygun değil",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.transparent,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                                : res
                                    ? await rememberPasswordPageController
                                        .changePass(
                                            ref
                                                .read(changePasswordProvider
                                                    .notifier)
                                                .state
                                                .pass,
                                            context)
                                    : Fluttertoast.showToast(
                                        msg: "Şifreler aynı değil",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.transparent,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent),
                          padding:
                              MaterialStatePropertyAll(EdgeInsets.all(11.0)),
                          elevation: MaterialStatePropertyAll(10.0),
                          side: MaterialStatePropertyAll(
                              BorderSide(width: 1.0, color: Colors.white))),
                      child: const Text(
                        "Şifremi güncelle",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

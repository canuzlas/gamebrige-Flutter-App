import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamebrige/src/screens/passwordProceses/changePasswordPage/controller/changePasswordPageController.dart';
import 'package:gamebrige/src/screens/passwordProceses/changePasswordPage/state/changePassword_page_state.dart';

class ChangePasswordPageForms extends ConsumerWidget {
  ChangePasswordPageForms({super.key});

  ChangePasswordPageController changePasswordPageController =
      ChangePasswordPageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        //top text
        const Padding(
          padding: EdgeInsets.only(top: 45.0),
          child: Center(
            child: Text(
              "Güvenli bir şifre oluştur.",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black87),
            ),
          ),
        ),
        //input for pass
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              child: TextFormField(
                validator: ref.read(changePasswordProvider.notifier).validate,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Şifre',
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: (txt) {
                  ref.read(changePasswordProvider.notifier).statePass(txt);
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
                  ref.read(changePasswordProvider.notifier).stateRepass(txt);
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
            onPressed: () {
              final res = ref.read(changePasswordProvider.notifier).doCheck();
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
                          ? print("fnc")
                          : Fluttertoast.showToast(
                              msg: "Şifreler uyuşmuyor",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.transparent,
                              textColor: Colors.white,
                              fontSize: 16.0);
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                padding: MaterialStatePropertyAll(EdgeInsets.all(11.0)),
                elevation: MaterialStatePropertyAll(10.0),
                side: MaterialStatePropertyAll(
                    BorderSide(width: 1.0, color: Colors.white))),
            child: const Text(
              "Güncelle",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}

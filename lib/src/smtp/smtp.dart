import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<bool> SMTP(code, mail) async {
  final smtpServer = SmtpServer(
    dotenv.env["SMTP_SERVER"]!,
    port: int.parse(dotenv.env["SMTP_PORT"]!),
    username: dotenv.env["SMTP_MAIL"],
    password: dotenv.env["SMTP_PASS"],
  );

  // Create our message.
  final message = Message()
    ..from = const Address("help@gamebrige.com", 'gamebrige')
    ..recipients.add(mail)
    ..subject = 'E-postanı onayla'
    ..text = ''
    ..html =
        "<h1>GAMEBRİGE'E HOŞGELDİN</h1>\n<h3>E-posta onay kodunuz: ${code} </h3>";

  try {
    await send(message, smtpServer);
    Fluttertoast.showToast(
        msg: "Mail adresini kontrol et.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.transparent,
        textColor: Colors.white,
        fontSize: 16.0);
    return true;
  } on MailerException catch (e) {
    Fluttertoast.showToast(
        msg: "Sistemsel Hata.!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.transparent,
        textColor: Colors.white,
        fontSize: 16.0);
    return false;
  }
  // DONE
}

Future<bool> SMTPASS(code, mail, context) async {
  final smtpServer = SmtpServer(
    dotenv.env["SMTP_SERVER"]!,
    port: int.parse(dotenv.env["SMTP_PORT"]!),
    username: dotenv.env["SMTP_MAIL"],
    password: dotenv.env["SMTP_PASS"],
  );

  // Create our message.
  final message = Message()
    ..from = const Address("help@gamebrige.com", 'gamebrige')
    ..recipients.add(mail)
    ..subject = 'Şifre değişikliği'
    ..text = ''
    ..html = "<h1>Şifre değişikliği için</h1>\n<h3>onay kodunuz: ${code} </h3>";

  try {
    await send(message, smtpServer);
    Fluttertoast.showToast(
        msg: "Mail adresini kontrol et.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.transparent,
        textColor: Colors.white,
        fontSize: 16.0);
    return true;
  } on MailerException catch (e) {
    Fluttertoast.showToast(
        msg: "Sistemsel Hata.!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.transparent,
        textColor: Colors.white,
        fontSize: 16.0);
    return false;
  }
  // DONE
}

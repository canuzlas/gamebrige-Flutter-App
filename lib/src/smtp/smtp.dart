import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    ..from = const Address("mailer@falhub.com", 'gamebrige')
    ..recipients.add(mail)
    ..subject = 'E-postanı onayla'
    ..text = ''
    ..html =
        "<h1>GAMEBRİGE'E HOŞGELDİN</h1>\n<h3>E-posta onay kodunuz: ${code} </h3>";

  try {
    var deneme = await send(message, smtpServer);
    print(deneme);
    return true;
  } on MailerException catch (e) {
    print(e);
    return false;
  }
  // DONE
}

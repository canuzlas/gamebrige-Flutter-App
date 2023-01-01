import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<bool> SMTP(code, mail) async {
  // Note that using a username and password for gmail only works if
  // you have two-factor authentication enabled and created an App password.
  // Search for "gmail app password 2fa"
  // The alternative is to use oauth.
  //String username = 'mailertestdeneme@gmail.com';
  //String password = '120253534563';

  //final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.
  final smtpServer = SmtpServer(
    "mail.falhub.com",
    port: 587,
    username: "mailer@falhub.com",
    password: "eDuJx7XLX7WamFA",
  );

  // Create our message.
  final message = Message()
    ..from = const Address("mailer@falhub.com", 'gamebrige')
    ..recipients.add(mail)
    ..subject = 'E-postanı onayla'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html =
        "<h1>GAMEBRİGE'E HOŞGELDİN</h1>\n<h3>E-posta onay kodnuz: ${code} </h3>";

  try {
    await send(message, smtpServer);
    return true;
  } on MailerException catch (e) {
    return false;
  }
  // DONE
}

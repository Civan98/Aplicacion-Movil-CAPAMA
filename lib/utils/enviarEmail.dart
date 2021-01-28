import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailReset {
  sendMail(String correo, String pass, String asunto, String mensaje) async {
    String username = 'capamaApp@gmail.com';
    String password = 'reportescapamaApp';

    final smtpServer = gmail(username, password);

    // Create our message.
    final message = Message()
      ..from = Address(username, 'CAPAMA')
      ..recipients.add(correo)
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = asunto
      ..text = '$mensaje $pass';
    // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  sendMailNotify(
      String correo, String estado, String asunto, String mensaje) async {
    String username = 'capamaApp@gmail.com';
    String password = 'reportescapamaApp';

    final smtpServer = gmail(username, password);

    // Create our message.
    final message = Message()
      ..from = Address(username, 'CAPAMA')
      ..recipients.add(correo)
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = asunto
      ..text = '$mensaje $estado';
    // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}

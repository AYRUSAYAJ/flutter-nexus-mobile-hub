
import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailService {
  static Future<void> sendEmail({
    required String subject,
    required String body,
    required List<String> recipients,
    List<String> cc = const [],
    List<String> bcc = const [],
    List<String> attachmentPaths = const [],
  }) async {
    final Email email = Email(
      subject: subject,
      body: body,
      recipients: recipients,
      cc: cc,
      bcc: bcc,
      attachmentPaths: attachmentPaths,
      isHTML: false,
    );
    
    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      throw Exception('Error sending email: $e');
    }
  }
}

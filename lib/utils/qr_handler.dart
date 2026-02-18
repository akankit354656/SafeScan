import 'package:url_launcher/url_launcher.dart';
import 'qr_classifier.dart';

class QRHandler {
  static Future<void> handle(String content) async {
    final type = QRClassifier.classify(content);

    switch (type) {
      case QRType.upiPayment:
        await _launch(content); // OS will ask which payment app to open
        break;

      case QRType.googleForm:
      case QRType.url:
        await _launch(content);
        break;

      case QRType.email:
        await _launch(content);
        break;

      case QRType.phone:
        await _launch(content);
        break;

      case QRType.sms:
        await _launch(content);
        break;

      case QRType.wifi:
        // Show wifi credentials to user (can't auto-connect on Flutter easily)
        break;

      case QRType.contact:
        // Parse and show vCard details
        break;

      case QRType.plainText:
        // Just show the text
        break;
    }
  }

  static Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
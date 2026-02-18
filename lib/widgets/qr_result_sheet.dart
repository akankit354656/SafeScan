import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/qr_classifier.dart';

class QRResultSheet extends StatelessWidget {
  final String content;
  final QRType type;

  const QRResultSheet({required this.content, required this.type, super.key});

  String get _label {
    switch (type) {
      case QRType.upiPayment: return '💳 Payment QR';
      case QRType.googleForm: return '📋 Google Form';
      case QRType.url: return '🌐 Website';
      case QRType.email: return '📧 Email';
      case QRType.phone: return '📞 Phone';
      case QRType.sms: return '💬 SMS';
      case QRType.wifi: return '📶 Wi-Fi';
      case QRType.contact: return '👤 Contact';
      case QRType.plainText: return '📝 Text';
    }
  }

  Future<void> _handleRedirect() async {
    final uri = Uri.parse(content);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(content, maxLines: 3, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _handleRedirect();
            },
            child: const Text('Open / Redirect'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
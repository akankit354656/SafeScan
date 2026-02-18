// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../utils/qr_classifier.dart';

// class QRResultSheet extends StatelessWidget {
//   final String content;
//   final QRType type;

//   const QRResultSheet({required this.content, required this.type, super.key});

//   String get _label {
//     switch (type) {
//       case QRType.upiPayment: return '💳 Payment QR';
//       case QRType.googleForm: return '📋 Google Form';
//       case QRType.url: return '🌐 Website';
//       case QRType.email: return '📧 Email';
//       case QRType.phone: return '📞 Phone';
//       case QRType.sms: return '💬 SMS';
//       case QRType.wifi: return '📶 Wi-Fi';
//       case QRType.contact: return '👤 Contact';
//       case QRType.plainText: return '📝 Text';
//     }
//   }

//   Future<void> _handleRedirect() async {
//     final uri = Uri.parse(content);
//     try {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } catch (e) {
//       debugPrint('Could not launch $content: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(_label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 10),
//           Text(content, maxLines: 3, overflow: TextOverflow.ellipsis),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await _handleRedirect();
//             },
//             child: const Text('Open / Redirect'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/qr_classifier.dart';
import '../utils/history_db.dart';
import '../models/qr_history_item.dart';

class QRResultSheet extends StatelessWidget {
  final String content;
  final QRType type;

  const QRResultSheet({required this.content, required this.type, super.key});

  String get _label {
    switch (type) {
      case QRType.upiPayment: return 'Payment QR';
      case QRType.googleForm: return 'Google Form';
      case QRType.url: return 'Website';
      case QRType.email: return 'Email';
      case QRType.phone: return 'Phone';
      case QRType.sms: return 'SMS';
      case QRType.wifi: return 'Wi-Fi';
      case QRType.contact: return 'Contact';
      case QRType.plainText: return 'Text';
    }
  }

  String get _emoji {
    switch (type) {
      case QRType.upiPayment: return '💳';
      case QRType.googleForm: return '📋';
      case QRType.url: return '🌐';
      case QRType.email: return '📧';
      case QRType.phone: return '📞';
      case QRType.sms: return '💬';
      case QRType.wifi: return '📶';
      case QRType.contact: return '👤';
      case QRType.plainText: return '📝';
    }
  }

  Future<void> _saveToHistory() async {
    final item = QRHistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: _label,
      emoji: _emoji,
      scannedAt: DateTime.now(),
    );
    await HistoryDB.instance.insert(item);
  }

  Future<void> _handleRedirect() async {
    await _saveToHistory();
    final uri = Uri.parse(content);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D44),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Type label row
          Row(
            children: [
              Text(_emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Sora',
                    ),
                  ),
                  const Text(
                    'QR Detected',
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontFamily: 'Sora'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Content box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F1A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF2D2D44)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFD1D5DB),
                      fontSize: 13,
                      fontFamily: 'Sora',
                      height: 1.5,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: content));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Copied to clipboard'),
                        backgroundColor: const Color(0xFF1E1E2E),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.copy_rounded, color: Color(0xFF6B7280), size: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Open button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C83FD),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _handleRedirect();
              },
              child: const Text(
                'Open & Redirect',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Save only button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () async {
                await _saveToHistory();
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text(
                'Save to History Only',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontFamily: 'Sora',
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
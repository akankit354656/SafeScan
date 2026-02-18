// import 'package:flutter/material.dart';

// class ScanScreen extends StatelessWidget {
//   const ScanScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Scan QR")),
//       body: const Center(
//         child: Text("Scanning Screen"),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../utils/qr_classifier.dart';
import '../widgets/qr_result_sheet.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isDetected = false; // prevents multiple detections at once

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          if (_isDetected) return; // ignore if already showing result

          final barcode = barcodeCapture.barcodes.first;
          final String? content = barcode.rawValue;

          if (content != null) {
            setState(() => _isDetected = true);

            final type = QRClassifier.classify(content);

            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => QRResultSheet(content: content, type: type),
            ).then((_) {
              // reset after bottom sheet is closed so user can scan again
              setState(() => _isDetected = false);
            });
          }
        },
      ),
    );
  }
}


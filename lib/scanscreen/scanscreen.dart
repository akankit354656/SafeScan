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

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          final List<Barcode> barcodes = barcodeCapture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              debugPrint('Scanned QR: $code');
            }
          }
        },
      ),
    );
  }
}


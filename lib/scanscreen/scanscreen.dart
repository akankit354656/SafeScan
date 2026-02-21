import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../utils/qr_classifier.dart';
import '../widgets/qr_result_sheet.dart';
import 'package:qr_scanner_app/theme/theme_provider.dart'; // adjust path if needed

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isDetected = false;
  bool _torchOn = false;

  final MobileScannerController _controller = MobileScannerController(
    torchEnabled: false,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleTorch() {
    _controller.toggleTorch();
    setState(() => _torchOn = !_torchOn);
  }

  void _switchCamera() {
    _controller.switchCamera();
  }

  bool _isPickingImage = false; // add this with other state variables

  Future<void> _pickFromGallery() async {
    if (_isPickingImage) return; // prevent double tap
    _isPickingImage = true;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final BarcodeCapture? result = await _controller.analyzeImage(image.path);
      if (result == null || result.barcodes.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No QR code found in image')),
          );
        }
        return;
      }
      _handleDetection(result);
    } catch (e) {
      // silently ignore if picker is already active
    } finally {
      _isPickingImage = false; // always reset, even if error occurs
    }
  }

  void _handleDetection(BarcodeCapture barcodeCapture) {
    if (_isDetected) return;
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
      ).then((_) => setState(() => _isDetected = false));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch accent color from provider
    final accentColor = context.watch<ThemeProvider>().accentColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Safe Scan",
          style: TextStyle(
            color: Color.fromARGB(255, 227, 227, 227),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 43, 54, 63),
        actions: [
          IconButton(
            icon: Icon(Icons.image, color: accentColor),
            onPressed: _pickFromGallery,
          ),
          IconButton(
            icon: Icon(
              _torchOn ? Icons.flashlight_off : Icons.flashlight_on,
              color: accentColor,
            ),
            onPressed: _toggleTorch,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt, color: accentColor),
            onPressed: _switchCamera,
          ),
        ],
      ),
      body: MobileScanner(controller: _controller, onDetect: _handleDetection),
    );
  }
}

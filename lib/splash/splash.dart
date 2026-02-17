import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_scanner_app/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String _fullText = "SAFE SCAN";
  String _displayedText = "";
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTypewriterEffect();
  }

  void _startTypewriterEffect() {
    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_charIndex < _fullText.length) {
        setState(() {
          _displayedText += _fullText[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();

        // 👇 Typewriter complete hone ke baad navigate
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>  const HomePage(),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 119, 121),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 🔹 LOGO
            Image.asset(
              'assets/Screenshot 2026-02-18 003637.png', // 👈 yaha apna image path
              height: 120,
            ),

            const SizedBox(height: 20),

            // 🔹 TYPEWRITER TEXT
            Text(
              _displayedText,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

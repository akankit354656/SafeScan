import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner_app/screens/history_screen.dart';
import 'package:qr_scanner_app/settings/settings.dart';
import 'package:qr_scanner_app/splash/splash.dart';
import 'package:qr_scanner_app/scanscreen/scanscreen.dart';
import 'package:qr_scanner_app/theme/theme_provider.dart'; // adjust path if needed

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = context.watch<ThemeProvider>().accentColor;
    return MaterialApp(
      title: 'Safe Scan',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

// ---------------- HOME PAGE ----------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Watch accent color from provider
    final accentColor = context.watch<ThemeProvider>().accentColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Safe Scan",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: accentColor.withValues(alpha: 0.2),
        actions: [
          IconButton(
            icon: Icon(Icons.image, color: accentColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.flashlight_on, color: accentColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt, color: accentColor),
            onPressed: () {},
          ),
        ],
      ),

      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentColor.withValues(alpha: 0.6),
                accentColor.withValues(alpha: 0.4),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.only(top: 50),
            children: [
              ListTile(
                leading: Icon(Icons.star_border_rounded, color: accentColor, size: 28),
                title: const Text('Favourites',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.settings_rounded, color: accentColor, size: 28),
                title: const Text('Settings',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Settings()));
                },
              ),
              ListTile(
                leading: Icon(Icons.history_rounded, color: accentColor, size: 28),
                title: const Text('History',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const HistoryScreen()));
                },
              ),
            ],
          ),
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              accentColor.withValues(alpha: 0.6),
              accentColor.withValues(alpha: 0.2),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to Safe Scan",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ScanScreen()));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: accentColor, // ← accent color on button
                ),
                child: const Text(
                  "Start Scanning",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
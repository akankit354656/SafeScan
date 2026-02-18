

import 'package:flutter/material.dart';
import 'package:qr_scanner_app/screens/history_screen.dart';
import 'package:qr_scanner_app/settings/settings.dart';

// Screens
import 'package:qr_scanner_app/splash/splash.dart';
import 'package:qr_scanner_app/scanscreen/scanscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Scan',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // App starts here
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
            icon: const Icon(
              Icons.image,
              color: Color.fromARGB(255, 227, 227, 227),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.flashlight_on,
              color: Color.fromARGB(255, 227, 227, 227),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.camera_alt,
              color: Color.fromARGB(255, 227, 227, 227),
            ),
            onPressed: () {},
          ),
        ],
      ),

      // ---------------- DRAWER ----------------
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 17, 66, 101),
                Color.fromARGB(255, 0, 5, 9),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.only(top: 50),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.star_border_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                title: const Text(
                  'Favourites',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Settings()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.history_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                title: const Text(
                  'History',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // ---------------- BODY ----------------
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 17, 67, 103),
              Color.fromARGB(255, 0, 22, 38),
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
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScanScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  backgroundColor: const Color.fromARGB(255, 227, 227, 227),
                ),
                child: const Text(
                  "Start Scanning",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

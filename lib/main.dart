import 'package:flutter/material.dart';

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

      home: HomePage(),
    );
  }
}

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
        title: const Text("Safe Scan"),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(icon: const Icon(Icons.image), onPressed: () {}),
          IconButton(icon: const Icon(Icons.flashlight_on), onPressed: () {}),
          IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.indigo,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(Icons.star_border_rounded, color: Colors.black, size: 28),
              title: const Text(
                'Favourites',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => Navigator.pop(context), // Closes the drawer
            ),
            ListTile(
              leading: const Icon(
                Icons.settings_rounded,
                color: Colors.black,
                size: 28,
              ),
              title: const Text('Settings',style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.history_rounded, color: Colors.black, size: 28),
              title: const Text('History',style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Welcome to Safe Scan",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

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
      backgroundColor:  const Color.fromARGB(255, 0, 253, 114),
      appBar: AppBar(
        title: const Text("Safe Scan"),
        backgroundColor: const Color.fromARGB(255, 43, 244, 3),
        actions: [
          IconButton(icon: const Icon(Icons.image), onPressed: () {}),
          IconButton(icon: const Icon(Icons.flashlight_on), onPressed: () {}),
          IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 0, 255, 195), Color.fromARGB(255, 21, 255, 0)],
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
                  color: Colors.black,
                  size: 28,
                ),
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
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.history_rounded,
                  color: Colors.black,
                  size: 28,
                ),
                title: const Text(
                  'History',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
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

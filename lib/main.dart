import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Conditions_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';

import 'privacy_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDE7qEncybAhcLj8rQngi17Ox8jGBtnbZI",
            authDomain: "flutter-app-5eadf.firebaseapp.com",
            projectId: "flutter-app-5eadf",
            storageBucket: "flutter-app-5eadf.appspot.com",
            messagingSenderId: "1070617642636",
            appId: "1:1070617642636:web:d1aca3b0c8a9c292259da9",
            measurementId: "G-W5QDS0FPBT"));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mr. Event Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    ProfileScreen(),
    TermsScreen(),
    PrivacyScreen(),
    Text('Logout'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            backgroundColor: Color.fromARGB(255, 250, 148, 15),
            unselectedIconTheme: IconThemeData(color: Colors.white, opacity: 1),
            unselectedLabelTextStyle: TextStyle(color: Colors.white),
            selectedIconTheme:
                IconThemeData(color: Color.fromARGB(255, 250, 148, 15)),
            selectedLabelTextStyle:
                TextStyle(color: Color.fromARGB(255, 250, 148, 15)),
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                selectedIcon: Icon(Icons.home_filled),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                selectedIcon: Icon(Icons.person),
                label: Text('Profile'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.description),
                selectedIcon: Icon(Icons.description),
                label: Text('Terms & Conditions'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.privacy_tip),
                selectedIcon: Icon(Icons.privacy_tip),
                label: Text('Privacy Policy'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.logout),
                selectedIcon: Icon(Icons.logout),
                label: Text('Logout'),
              ),
            ],
          ),
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}

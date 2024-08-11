import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/allevents.dart';
import 'package:events/bookingsScreen.dart';
import 'package:events/userAdminDetails.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalAdmins = 0;
  int totalUsers = 0;
  int totalEvents = 0;
  int totalBookings = 0;
  @override
  void initState() {
    super.initState();
    _getAdminAndUserCount();
    _getTotalEventsCount();
    _getTotalBookingsCount();
  }

  Future<void> _getTotalBookingsCount() async {
    int bookingsCount = 0;
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('isAdmin', isEqualTo: true)
        .get();
    for (var doc in usersSnapshot.docs) {
      QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(doc.id)
          .collection('bookings')
          .get();
      bookingsCount += bookingsSnapshot.docs.length;
    }
    setState(() {
      totalBookings = bookingsCount;
    });
  }

  Future<void> _getTotalEventsCount() async {
    int eventsCount = 0;
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('isAdmin', isEqualTo: true)
        .get();
    for (var doc in usersSnapshot.docs) {
      QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(doc.id)
          .collection('events')
          .get();
      eventsCount += eventsSnapshot.docs.length;
    }
    setState(() {
      totalEvents = eventsCount;
    });
  }

  Future<void> _getAdminAndUserCount() async {
    QuerySnapshot usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      totalAdmins = usersSnapshot.docs.where((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return data.containsKey('isAdmin') && data['isAdmin'] == true;
      }).length;
      totalUsers = usersSnapshot.docs.where((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return !data.containsKey('isAdmin') || data['isAdmin'] == false;
      }).length;
    });
  }

  void _showUserDetails(bool isAdmin) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsScreen(isAdmin: isAdmin),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black45,
                offset: Offset(3.0, 3.0),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          children: [
            GestureDetector(
              onTap: () {
                _showUserDetails(true);
              },
              child: _buildStatCard('Admins', '$totalAdmins Admins Registered',
                  Colors.red, Icons.admin_panel_settings),
            ),
            GestureDetector(
              onTap: () {
                _showUserDetails(false);
              },
              child: _buildStatCard('Users', '$totalUsers Users Registered',
                  Colors.green, Icons.person),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventsScreen(),
                  ),
                );
              },
              child: _buildStatCard(
                  'Total Complexes',
                  '$totalEvents Complexes Registered',
                  Colors.blue,
                  Icons.event),
            ),
            GestureDetector(
              //
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingsScreen(),
                  ),
                );
              },
              child: _buildStatCard(
                  'Active Bookings',
                  '$totalBookings Bookings Registered',
                  Colors.purple,
                  Icons.book_online),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildStatCard(
      String title, String count, MaterialColor color, IconData icon) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color[100]!, color[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40.0, color: color[700]),
              SizedBox(height: 20.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: color[700],
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                count,
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: DashboardScreen(),
    );
  }
}

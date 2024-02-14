import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'food_delivery_home_page.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  // Method to handle user logout
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FoodDeliveryHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.teal[700], // Teal[700] color for the title
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black45), // Black.45 color for the back arrow
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 100, // Increased radius to make it bigger
                backgroundImage: AssetImage('lib/assets/profile_picture.png'), // Corrected to use AssetImage
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person), // User icon
                  SizedBox(width: 10),
                  Text(
                    '${user?.email ?? "Not logged in"}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 300, // Set button width
                height: 50, // Set button height
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal[700], // Background color
                    onPrimary: Colors.white, // Text Color (Foreground color)
                  ),
                  onPressed: () => _logout(context), // Pass context to _logout method
                  icon: Icon(Icons.logout),
                  label: Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

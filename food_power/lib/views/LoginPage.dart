import 'package:flutter/material.dart';
import 'package:food_power/views/SignUpPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'food_menu_view.dart';


class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amber[200], // Set your desired background color here
        padding: EdgeInsets.all(16.0), // Add padding if needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the column
          children: [
            Text(
              'Welcome Back',
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontSize: 25),
              ),
            ),
            SizedBox(height: 20), // Add spacing between widgets
            Image.asset('lib/assets/delivery.png', width: 300),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                textStyle: TextStyle(fontSize: 18.0),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  FoodMenuScreen()));
                } catch (e) {
                  print(e); // Handle errors
                }
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.person_add_alt_1_outlined),
              label: Text("Sign Up", style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(color: Colors.black, letterSpacing: .5, fontSize: 15),
              ) ,),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUpPage()));
              },
            )
          ],
        ),
      ),
    );
  }
}

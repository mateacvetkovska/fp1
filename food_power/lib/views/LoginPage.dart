import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'food_menu_view.dart';
import 'SignUpPage.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: Container(
        color: Color(0xffF1CE74),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!keyboardIsOpen)
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 40,),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            if (!keyboardIsOpen) SizedBox(height: 20),
            if (!keyboardIsOpen)
              Image.asset('lib/assets/delivery.png', width: 300),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                primary: Colors.teal[300],
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 90.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                textStyle: GoogleFonts.nunitoSans(fontSize: 18.0, fontWeight: FontWeight.w700),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FoodMenuScreen()));
                } catch (e) {
                  print(e);
                }
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.person_add_alt, color: Colors.white),
              label: Text(
                "Sign Up",
                style: GoogleFonts.nunitoSans(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
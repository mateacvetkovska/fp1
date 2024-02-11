import 'package:flutter/material.dart';
import 'package:food_power/views/food_menu_view.dart';
import 'package:food_power/views/SignUpPage.dart';
import 'package:food_power/views/LoginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';


class FoodDeliveryHomePage extends StatelessWidget {
  const FoodDeliveryHomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1CE74),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Transform.rotate(
                    angle: pi / -4, // Import 'dart:math' to use 'pi'
                    child: Image.asset('lib/assets/6.png', width: 40),
                  ),
                  Spacer(flex: 3,),
                  Image.asset('lib/assets/2.png', width: 60),
                  Spacer(flex: 2),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset('lib/assets/5.png', width: 300),
                  Spacer(),
                  Image.asset('lib/assets/4.png', width: 60),
                ],
              ),
            ),
            Text(
                'The best food',
                style: GoogleFonts.nunitoSans( // Using Google Fonts for the text
                  textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontSize: 25, fontWeight: FontWeight.bold,),
                ),
              ),
           Text(
                'right on time',
                style: GoogleFonts.nunitoSans( // Using Google Fonts for the text
                  textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontSize: 25, fontWeight: FontWeight.bold,),
                ),
              ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FoodMenuScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.teal[300],
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: Text(
                  'Start Ordering',
                  style: GoogleFonts.nunitoSans( // Using Google Fonts for the text
                    textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.bold,fontSize: 17),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              child: Text(
                'Sign Up Now',
                style: GoogleFonts.nunitoSans( // Using Google Fonts for the text
                  textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.bold,fontSize: 17),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text(
                'Log In',
                style: GoogleFonts.nunitoSans( // Using Google Fonts for the text
                  textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.bold,fontSize: 17),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

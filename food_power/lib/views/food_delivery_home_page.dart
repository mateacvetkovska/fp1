import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:math';
import 'LoginPage.dart';

class FoodDeliveryHomePage extends StatefulWidget {
  const FoodDeliveryHomePage({Key? key}) : super(key: key);

  @override
  State<FoodDeliveryHomePage> createState() => _FoodDeliveryHomePageState();
}

class _FoodDeliveryHomePageState extends State<FoodDeliveryHomePage> {
  @override
  Widget build(BuildContext context) {
    double textContainerHeight = MediaQuery.of(context).size.height * 0.175;
    double screenPaddingHorizontal = 16.0;
    double textPaddingLeft = screenPaddingHorizontal;

    return Scaffold(
      backgroundColor: Color(0xffF1CE74),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenPaddingHorizontal, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Transform.rotate(
                      angle: pi / -4,
                      child: Image.asset('lib/assets/6.png', width: 40),
                    ),
                    Spacer(flex: 3),
                    Image.asset('lib/assets/2.png', width: 60),
                    Spacer(flex: 2),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenPaddingHorizontal, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset('lib/assets/5.png', width: 300),
                    Spacer(),
                    Image.asset('lib/assets/4.png', width: 60),
                  ],
                ),
              ),
              Container(
                height: textContainerHeight,
                padding: EdgeInsets.only(left: textPaddingLeft),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'The best food,\nright on time...',
                      textStyle: GoogleFonts.nunitoSans(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      speed: Duration(milliseconds: 100),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(child: _buildActionButtons(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.teal[300],
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            child: Text(
              'Get Started',
              style: GoogleFonts.nunitoSans(
                color: Colors.white,
                letterSpacing: .7,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
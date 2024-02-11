import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  Color myColor = Color(0xffF1CE74);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xffF1CE74),
      appBar: AppBar(
        title: Text('About Us', style: GoogleFonts.nunitoSans(
          textStyle: TextStyle(color: Colors.amber, letterSpacing: .5, fontSize: 25, fontWeight: FontWeight.bold,),)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Empowering Your Workplace Meals',
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(color: Colors.black, letterSpacing: .5, fontSize: 25, fontWeight: FontWeight.bold,),)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Food Power revolutionizes the way you enjoy meals at your workplace. Our web platform simplifies the process of selecting and booking hot meals for the next day, ensuring you always have access to delicious, ready-to-eat options. Whether you are at work or planning ahead from home, Food Power brings the convenience of choosing from a curated menu right to your fingertips.',
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(color: Colors.black, letterSpacing: .5, fontSize: 20, ),)
              ),
            ),
            // You can continue adding more sections here
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Convenience at Its Core',
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(color: Colors.black, letterSpacing: .5, fontSize: 25, fontWeight: FontWeight.bold,),)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Our platform stands out by offering comprehensive meal overviews, enabling users to select not only their preferred dishes but also choose convenient pick-up or delivery times. The dual-access system ensures that both customers and employees can navigate the platform with ease, maintaining a clear view of order statuses.',
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(color: Colors.black, letterSpacing: .5, fontSize: 20,),)
              ),
            ),
            // Include images, videos, or other media to elaborate on your "About Us" narrative
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('lib/assets/food.gif'), // Replace with your asset name
              ),
            ),
            // ... additional content ...
          ],
        ),
      ),
    );
  }
}

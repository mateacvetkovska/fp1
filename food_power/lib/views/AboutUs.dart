import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_power/widgets/CustomCard.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> with TickerProviderStateMixin {
  late AnimationController _slideControllerLeft;
  late Animation<Offset> _slideAnimationLeft;
  late AnimationController _slideControllerRight;
  late Animation<Offset> _slideAnimationRight;

  @override
  void initState() {
    super.initState();

    _slideControllerLeft = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _slideAnimationLeft = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideControllerLeft, curve: Curves.easeInOut),
    );

    _slideControllerRight = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _slideAnimationRight = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideControllerRight, curve: Curves.easeInOut),
    );

    _slideControllerLeft.forward();
    _slideControllerRight.forward();
  }

  @override
  void dispose() {
    _slideControllerLeft.dispose();
    _slideControllerRight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('About Us', style: GoogleFonts.nunitoSans(
          textStyle: TextStyle(color: Colors.teal[700], letterSpacing: .5, fontSize: 25, fontWeight: FontWeight.bold),
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black45),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SlideTransition(
                position: _slideAnimationLeft,
                child: CustomCard(
                  title: 'Empowering Your Workplace Meals',
                  text: 'Food Power revolutionizes the way you enjoy meals at your workplace. Our web platform simplifies the process of selecting and booking hot meals for the next day, ensuring you always have access to delicious, ready-to-eat options. Whether you are at work or planning ahead from home, Food Power brings the convenience of choosing from a curated menu right to your fingertips.',
                ),
              ),
              SizedBox(height: 30),
              SlideTransition(
                position: _slideAnimationRight,
                child: CustomCard(
                  title: 'Convenience at Its Core',
                  text: 'Our platform stands out by offering comprehensive meal overviews, enabling users to select not only their preferred dishes but also choose convenient pick-up or delivery times. The dual-access system ensures that both customers and employees can navigate the platform with ease, maintaining a clear view of order statuses.',
                ),
              ),
              SizedBox(height: 30),
              Center(child: Image.asset('lib/assets/food-cooker.gif')),
            ],
          ),
        ),
      ),
    );
  }
}
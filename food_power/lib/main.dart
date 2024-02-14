import 'package:flutter/material.dart';
import 'package:food_power/firebase_options.dart';
import 'package:food_power/views/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_power/views/food_delivery_home_page.dart';
import 'package:food_power/views/food_menu_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Check if the user is already logged in
  User? user = FirebaseAuth.instance.currentUser;
  Widget initialScreen = user != null ? FoodMenuScreen() : FoodDeliveryHomePage();

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({Key? key, required this.initialScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator if the connection state is waiting
          }
          if (snapshot.hasData && snapshot.data != null) {
            return FoodMenuScreen(); // If the user is logged in, show the FoodMenuScreen
          } else {
            return initialScreen; // If the user is not logged in, show the LoginPage or the initialScreen
          }
        },
      ),
    );
  }
}

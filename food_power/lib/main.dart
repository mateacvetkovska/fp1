import 'package:flutter/material.dart';
import 'package:food_power/firebase_options.dart';
import 'package:food_power/views/food_delivery_home_page.dart'; // Make sure to import the home page correctly
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FoodDeliveryHomePage(),
    );
  }
}
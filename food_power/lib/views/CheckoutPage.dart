import 'package:flutter/material.dart';
import 'package:food_power/views/food_menu_view.dart';

import 'ReviewPage.dart';

class CheckoutPage extends StatelessWidget {
  final int orderId;

  const CheckoutPage({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black45),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FoodMenuScreen())),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'lib/assets/foodpower_logo.png',
          height: 40,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'lib/assets/success_image.gif',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 24),
            Text(
              'Order successfully placed',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Your order has been successfully\nprocessed and will soon be delivered to you.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewPage(orderId: orderId,)));
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.teal[600], // Teal color
            padding: EdgeInsets.symmetric(vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: Text(
            'Write a Review',
            style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

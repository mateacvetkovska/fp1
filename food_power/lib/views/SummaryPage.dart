import 'package:flutter/material.dart';
import 'package:food_power/database/database_helper.dart';
import 'package:food_power/models/Order.dart';
import 'package:food_power/views/CheckoutPage.dart';

class SummaryPage extends StatelessWidget {
  final String userId;
  final double totalPrice;
  final String? deliveryAddress;
  final double deliveryFee;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final bool isPickup;

  const SummaryPage({
    Key? key,
    required this.userId,
    required this.totalPrice,
    this.deliveryAddress,
    required this.deliveryFee,
    required this.selectedDate,
    required this.selectedTime,
    required this.isPickup,
  }) : super(key: key);

  String _formatDateTime(BuildContext context, DateTime date, TimeOfDay time) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final dateString = "${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
    final timeString = localizations.formatTimeOfDay(time, alwaysUse24HourFormat: false);
    return "$dateString $timeString";
  }

  @override
  Widget build(BuildContext context) {

    final dateTimeString = _formatDateTime(context,selectedDate, selectedTime);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("User ID: $userId"),
            Text("Total Price: \$${totalPrice.toStringAsFixed(2)}"),
            if (!isPickup && deliveryAddress != null) Text("Delivery Address: $deliveryAddress"),
            if (!isPickup) Text("Delivery Fee: \$${deliveryFee.toStringAsFixed(2)}"),
            Text("Date: $selectedDate"),
            Text("Time: $selectedTime"),
            Text("Order Type: ${isPickup ? "Pickup" : "Delivery"}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final order = {
                  'userId': userId,
                  'totalPrice': totalPrice,
                  'deliveryAddress': deliveryAddress ?? "",
                  'deliveryFee': deliveryFee,
                  'dateTime': dateTimeString,
                  'isPickup': isPickup ? 1 : 0,
                };
                try {
                  await DatabaseHelper.instance.insertOrder(Order.fromMap(order));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CheckoutPage()));
                } catch (e) {
                  print("Error inserting order: $e");
                  // Optionally, show an error message to the user
                }
              },
              child: Text('Confirm Order'),

            ),
          ],
        ),
      ),
    );
  }
}


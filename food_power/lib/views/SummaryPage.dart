import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final dateString = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final timeString = localizations.formatTimeOfDay(time, alwaysUse24HourFormat: false);
    return "$dateString $timeString";
  }

  @override
  Widget build(BuildContext context) {
    final dateTimeString = _formatDateTime(context, selectedDate, selectedTime);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary', style: GoogleFonts.nunitoSans()),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Price of Cart Items:", style: GoogleFonts.nunitoSans(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("\$${totalPrice.toStringAsFixed(2)}", style: GoogleFonts.nunitoSans(fontSize: 16)),
                      if (!isPickup && deliveryAddress != null) Text("Delivery Address:", style: GoogleFonts.nunitoSans(fontSize: 18, fontWeight: FontWeight.bold)),
                      if (!isPickup && deliveryAddress != null) Text("$deliveryAddress", style: GoogleFonts.nunitoSans(fontSize: 16)),
                      if (!isPickup) Text("Delivery Fee:", style: GoogleFonts.nunitoSans(fontSize: 18, fontWeight: FontWeight.bold)),
                      if (!isPickup) Text("\$${deliveryFee.toStringAsFixed(2)}", style: GoogleFonts.nunitoSans(fontSize: 16)),
                      Text("Total:", style: GoogleFonts.nunitoSans(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("\$${(totalPrice + deliveryFee).toStringAsFixed(2)}", style: GoogleFonts.nunitoSans(fontSize: 16)),
                      Text("Date:", style: GoogleFonts.nunitoSans(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("$dateTimeString", style: GoogleFonts.nunitoSans(fontSize: 16)),
                      Text("Order Type:", style: GoogleFonts.nunitoSans(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("${isPickup ? "Pickup" : "Delivery"}", style: GoogleFonts.nunitoSans(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
              child: ElevatedButton(
                onPressed: () async {
                  final order = Order(
                    id: null,
                    userId: userId,
                    totalPrice: totalPrice,
                    deliveryAddress: deliveryAddress ?? "Not Applicable",
                    deliveryFee: deliveryFee,
                    dateTime: dateTimeString,
                    isPickup: isPickup,
                  );
                  try {
                    int orderId = await DatabaseHelper.instance.insertOrder(order);
                    await DatabaseHelper.instance.clearCart(userId);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckoutPage(orderId: orderId,)));
                  } catch (e) {
                    print("Error inserting order: $e");
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error confirming order. Please try again.')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                  textStyle: GoogleFonts.nunitoSans(fontSize: 18),
                ),
                child: Text('Confirm Order'),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

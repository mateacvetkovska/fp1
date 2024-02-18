import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_power/views/MapPage.dart';
import '../database/database_helper.dart';
import 'SummaryPage.dart';

class DateTimeSelectionPage extends StatefulWidget {
  @override
  _DateTimeSelectionPageState createState() => _DateTimeSelectionPageState();
}

class _DateTimeSelectionPageState extends State<DateTimeSelectionPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DeliveryOption? _deliveryOption = DeliveryOption.pickUp;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Date & Time '),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                'Select Date',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                selectedDate != null ? "${selectedDate!.toLocal()}".split(' ')[0] : 'No date chosen',
                style: TextStyle(color: Colors.black54),
              ),
              trailing: Icon(Icons.calendar_today, color: Colors.black),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text(
                'Select Time',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                selectedTime != null ? selectedTime!.format(context) : 'No time chosen',
                style: TextStyle(color: Colors.black54),
              ),
              trailing: Icon(Icons.access_time, color: Colors.black),
              onTap: () => _selectTime(context),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: const Text('Pick Up'),
                  leading: Radio<DeliveryOption>(
                    value: DeliveryOption.pickUp,
                    groupValue: _deliveryOption,
                    onChanged: (DeliveryOption? value) {
                      setState(() {
                        _deliveryOption = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Delivery'),
                  leading: Radio<DeliveryOption>(
                    value: DeliveryOption.delivery,
                    groupValue: _deliveryOption,
                    onChanged: (DeliveryOption? value) {
                      setState(() {
                        _deliveryOption = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('Proceed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  textStyle: TextStyle(fontSize: 18.0),
                ),
                onPressed: () async {
                  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                  final totalPrice = await DatabaseHelper.instance.getTotalCartPrice(userId);

                  if (_deliveryOption == DeliveryOption.delivery) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPage(
                          userId: userId,
                          selectedDate: selectedDate!,
                          selectedTime: selectedTime!,
                          deliveryOption: _deliveryOption!,
                          totalPrice: totalPrice,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SummaryPage(
                          userId: userId,
                          totalPrice: totalPrice ,
                          deliveryAddress: 'Not Applicable',
                          deliveryFee: 0.0,
                          selectedDate: selectedDate!,
                          selectedTime: selectedTime!,
                          isPickup: true,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}

enum DeliveryOption { pickUp, delivery }

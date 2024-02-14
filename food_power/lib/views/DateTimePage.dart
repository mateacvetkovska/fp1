import 'package:flutter/material.dart';
import 'package:food_power/views/MapPage.dart';

import 'CheckoutPage.dart';

class DateTimeSelectionPage extends StatefulWidget {
  @override
  _DateTimeSelectionPageState createState() => _DateTimeSelectionPageState();
}

class _DateTimeSelectionPageState extends State<DateTimeSelectionPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  // Step 1: Define the Delivery Option Enum
  DeliveryOption? _deliveryOption = DeliveryOption.pickUp; // default value

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
      body: SingleChildScrollView( // Wrapped in SingleChildScrollView for better UI experience
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Existing widgets for date and time selection
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
            // Step 3: Integrate the Delivery Option UI
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
                child: Text('Checkout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  textStyle: TextStyle(fontSize: 18.0),
                ),
                onPressed: () {
                  // Check the selected delivery option and navigate accordingly
                  if (_deliveryOption == DeliveryOption.delivery) {
                    // If 'Delivery' is selected, navigate to the MapPage
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()));
                  } else {
                    // If 'Pick Up' is selected, navigate to the CheckoutPage
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutPage()));
                  }
                },
              ),
            ),
            // Add more widgets as needed
          ],
        ),
      ),
    );
  }
}

enum DeliveryOption { pickUp, delivery } // Step 1: Moved outside the class if needed globally or inside the class if scoped to this widget only

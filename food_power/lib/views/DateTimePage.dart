import 'package:flutter/material.dart';

class DateTimeSelectionPage extends StatefulWidget {
  @override
  _DateTimeSelectionPageState createState() => _DateTimeSelectionPageState();
}

class _DateTimeSelectionPageState extends State<DateTimeSelectionPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

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
      body: Column(
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text('Checkout'),
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20.0),
                textStyle: TextStyle(fontSize: 18.0),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DateTimeSelectionPage()));
              },
            ),
          ),
          // Add more widgets as needed
        ],
      ),
    );
  }
}

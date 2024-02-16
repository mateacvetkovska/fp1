import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _reviewController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _takePicture() async {
    final PermissionStatus permissionStatus = await Permission.camera.request();
    if (permissionStatus == PermissionStatus.granted) {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        _imageFile = pickedFile;
      });
    } else {
      // Handle the case when camera permission is denied
      print('Camera permission is denied');
    }
  }

  Future<void> _sendReview() async {
    // Placeholder for sending review to the database
    // Here you would typically upload the image file along with the review text
    if (_imageFile != null) {
      // Upload the image file to your desired destination (e.g., server, cloud storage)
      // Replace the placeholder code below with your actual upload logic
      File image = File(_imageFile!.path);
      // Upload 'image' to your desired destination
      print('Image uploaded successfully!');
    }

    // You can also include the review text in your upload process
    String reviewText = _reviewController.text;
    print('Review Text: $reviewText');

    // Show a dialog indicating that the review has been sent
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Review Sent'),
          content: Text('Your review has been successfully sent.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write a Review', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal[700],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_imageFile != null)
              Image.file(
                File(_imageFile!.path),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _takePicture,
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.teal[700],
                shadowColor: Colors.teal[700],
                elevation: 5,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                textStyle: TextStyle(fontSize: 18, color: Colors.teal[700]),
              ),
              child: Text('Take Picture'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                labelText: 'Your Review',
                hintText: 'Enter your review...',
                hintStyle: TextStyle(color: Colors.black45),
                labelStyle: TextStyle(color: Colors.black45),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal[700]!),
                ),
              ),
              style: TextStyle(color: Colors.black45),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendReview,
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.teal[700],
                shadowColor: Colors.teal[700],
                elevation: 5,
                padding: EdgeInsets.symmetric(vertical: 20.0),
                textStyle: TextStyle(fontSize: 20, color: Colors.teal[700]),
              ),
              child: Text('Send Review'),
            ),
          ],
        ),
      ),
    );
  }
}

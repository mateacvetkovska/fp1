import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../database/database_helper.dart';

class ReviewPage extends StatefulWidget {
  final int orderId;
  const ReviewPage({Key? key, required this.orderId}) : super(key: key);

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
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Camera Permission'),
        content: Text('This app needs camera access to take pictures for reviews. Please enable camera access in the settings.'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Settings'),
            onPressed: () {
              AppSettings.openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      String filePath = 'review_photos/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      await firebase_storage.FirebaseStorage.instance.ref(filePath).putFile(imageFile);
      String downloadURL = await firebase_storage.FirebaseStorage.instance.ref(filePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<void> _sendReview() async {
    if (_imageFile != null) {
      String photoUrl = await uploadImage(File(_imageFile!.path));
      String reviewText = _reviewController.text;
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      await DatabaseHelper.instance.insertReview(
          userId, widget.orderId, photoUrl, reviewText);

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
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write a Review'),
        backgroundColor: Colors.teal,
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
              child: Text('Take Picture'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                labelText: 'Your Review',
                hintText: 'Enter your review...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendReview,
              child: Text('Send Review'),
            ),
          ],
        ),
      ),
    );
  }
}

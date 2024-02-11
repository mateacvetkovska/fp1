import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginPage.dart';
class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpPage({Key? key}) : super(key: key);

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF1CE74),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Sign Up', style: GoogleFonts.nunitoSans(color: Colors.white)),
      ),
      body: Container(
        color: Color(0xffF1CE74),
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!keyboardIsOpen) SizedBox(height: MediaQuery.of(context).size.height * 0.001),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        showSnackbar(context, 'The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        showSnackbar(context, 'An account already exists for that email.');
                      } else if (e.code == 'invalid-email') {
                        showSnackbar(context, 'The email address is not valid.');
                      } else {
                        showSnackbar(context, 'An error occurred. Please try again.');
                      }
                    } catch (e) {
                      showSnackbar(context, 'An error occurred. Please try again.');
                    }
                  },
                  child: Text('Sign Up', style: GoogleFonts.nunitoSans(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal[300],
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 90.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

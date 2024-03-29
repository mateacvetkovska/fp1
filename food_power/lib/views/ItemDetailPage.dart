import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'CartPage.dart';

class ItemDetailPage extends StatefulWidget {
  final Item item;

  const ItemDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int quantity = 1;
  String? orderNote;

  @override
  Widget build(BuildContext context) {
    final imagePath = 'lib/${widget.item.imageUrl}';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black45),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(imagePath, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name,
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: .5,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.remove), onPressed: _decrementQuantity),
                      Text('$quantity'),
                      IconButton(icon: Icon(Icons.add), onPressed: _incrementQuantity),
                    ],
                  ),
                  Text(
                    '\$${widget.item.price.toStringAsFixed(2)}',
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: .5,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: .5,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.item.description,
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: .5,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Order Note',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: .5,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Add a note (optional)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        orderNote = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Center(
                  child: ElevatedButton(
                    onPressed: _addItemToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[700],
                      onPrimary: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart),
                        SizedBox(width: 8),
                        Text(
                          'Add to cart',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _incrementQuantity() {
    setState(() => quantity++);
  }

  void _decrementQuantity() {
    if (quantity > 1) setState(() => quantity--);
  }

  Future<void> _addItemToCart() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to add items to the cart.')),
      );
      return;
    }

    await DatabaseHelper.instance.addToCart(widget.item.id, userId, quantity);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to cart')));
  }
}


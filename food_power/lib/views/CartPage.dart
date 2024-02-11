import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/database_helper.dart';
import '../models/item.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'DateTimePage.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Item>> cartItemsFuture;

  @override
  void initState() {
    super.initState();
    cartItemsFuture = loadCartItems();
  }

  Future<List<Item>> loadCartItems() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      return DatabaseHelper.instance.getCartItems(userId);
    }
    return [];
  }

  double getTotalPrice(List<Item> cartItems) {
    return cartItems.fold(0, (previousValue, item) => previousValue + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', textAlign: TextAlign.center,style: GoogleFonts.nunitoSans(
          textStyle: TextStyle(color: Colors.teal[700], letterSpacing: .5, fontSize: 25, fontWeight: FontWeight.bold,),)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Item>>(
              future: cartItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final cartItems = snapshot.data!;
                    return ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          margin: EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image.asset('lib/${item.imageUrl}', width: 64), // Item image
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(item.name, style: TextStyle(fontSize: 18)),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () => updateQuantity(item, -1),
                                ),
                                Text(item.quantity.toString()),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () => updateQuantity(item, 1),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => removeItem(item),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error loading cart items');
                  }
                }
                return CircularProgressIndicator();
              },
            ),
          ),
          FutureBuilder<List<Item>>(
            future: cartItemsFuture,
            builder: (context, snapshot) {
              final total = snapshot.hasData ? getTotalPrice(snapshot.data!) : 0.0;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal'),
                            Text('\$${total.toStringAsFixed(2)}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery fee'),
                            Text('Free'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total'),
                            Text('\$${total.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text('Choose Date and Time'),
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
        ],
      ),
    );
  }

  void updateQuantity(Item item, int delta) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      int newQuantity = item.quantity + delta;
      if (newQuantity < 1) newQuantity = 1;

      await DatabaseHelper.instance.updateItemQuantity(item.id, userId, newQuantity);
      if (mounted) {
        setState(() {
          cartItemsFuture = loadCartItems(); // Reload cart items to reflect the update
        });
      }
    }
  }

  void removeItem(Item item) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await DatabaseHelper.instance.removeItemFromCart(item.id, userId);
      if (mounted) {
        setState(() {
          cartItemsFuture = loadCartItems(); // Reload cart items to reflect the removal
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} removed from cart')));
      }
    }
  }
}

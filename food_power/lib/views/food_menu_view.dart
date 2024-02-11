import 'package:flutter/material.dart';
import 'package:food_power/database/database_helper.dart';
import 'package:food_power/models/item.dart';
import 'package:food_power/views/AboutUs.dart';
import 'package:food_power/views/CartPage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/food_item_cart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ItemDetailPage.dart';
import 'UserProfilePage.dart'; // Ensure this import is correct

class FoodMenuScreen extends StatefulWidget {
  const FoodMenuScreen({Key? key}) : super(key: key);

  @override
  _FoodMenuScreenState createState() => _FoodMenuScreenState();
}

class _FoodMenuScreenState extends State<FoodMenuScreen> {
  late Future<List<Item>> itemsFuture;
  List<Item> favorites = [];
  @override
  void initState() {
    super.initState();
    itemsFuture = DatabaseHelper.instance.getAllCatalogItems();
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.info_outline, color: Colors.black), onPressed: () {Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AboutUsPage()));}),
        title: Image.asset('lib/assets/foodpower_logo.png', height: 50),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
              onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CartPage()));}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Our Menu', style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(color: Colors.teal[700], letterSpacing: .5, fontSize: 25, fontWeight: FontWeight.bold,),)),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Item>>(
                future: itemsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final item = snapshot.data![index];
                          return GestureDetector( // Use GestureDetector for tap handling
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ItemDetailPage(item: item)),
                            ),
                            child: FoodItemCard(
                              image: 'lib/${item.imageUrl}', // Adjust as per your asset path
                              title: item.name,
                              price: '\$${item.price.toStringAsFixed(2)}',
                              rating: item.rating.toString(),
                              item: item,
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error fetching data'));
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) { // Assuming the profile is the third item
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserProfilePage()),
      );
    }
    // Handle other navigation for other tabs if necessary
  }
}


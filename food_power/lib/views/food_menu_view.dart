import 'dart:math';
import 'package:flutter/material.dart';
import 'package:food_power/database/database_helper.dart';
import 'package:food_power/models/item.dart';
import 'package:food_power/views/AboutUs.dart';
import 'package:food_power/views/CartPage.dart';
import 'package:food_power/views/ItemDetailPage.dart';
import 'package:food_power/views/UserProfilePage.dart';
import '../widgets/food_item_cart.dart';

class FoodMenuScreen extends StatefulWidget {
  const FoodMenuScreen({Key? key}) : super(key: key);

  @override
  _FoodMenuScreenState createState() => _FoodMenuScreenState();
}

class _FoodMenuScreenState extends State<FoodMenuScreen> {
  late Future<List<Item>> itemsFuture;
  List<Item> favorites = [];
  late Item _mealOfTheDay;
  bool isNotificationUnread = true;

  @override
  void initState() {
    super.initState();
    itemsFuture = DatabaseHelper.instance.getAllCatalogItems();
    _setMealOfTheDay();
  }

  void _setMealOfTheDay() {
    final Random random = Random();
    itemsFuture.then((items) {
      setState(() {
        _mealOfTheDay = items[random.nextInt(items.length)];
      });
    });
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.black45),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutUsPage()),
            );
          },
        ),
        title: Image.asset(
          'lib/assets/foodpower_logo.png',
          height: 50,
          alignment: Alignment.center,
        ),
        actions: <Widget>[
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black45),
                onPressed: () {
                  _showMealOfTheDay(context);
                  setState(() {
                    isNotificationUnread = false;
                  });
                },
              ),
              if (isNotificationUnread)
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black45),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Our Menu',
              style: TextStyle(
                color: Colors.teal[700],
                letterSpacing: .5,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ItemDetailPage(item: item)),
                            ),
                            child: FoodItemCard(
                              image: 'lib/${item.imageUrl}',
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
        items: [
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
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserProfilePage()),
      );
    }
  }

  void _showMealOfTheDay(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Meal of the Day'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Enjoy our special today:'),
                SizedBox(height: 8),
                Text(
                  _mealOfTheDay != null ? _mealOfTheDay.name : 'No meal selected',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _mealOfTheDay != null
                    ? Image.asset(
                  'lib/${_mealOfTheDay.imageUrl}',
                  height: 220,
                  width: 220,
                  fit: BoxFit.cover,
                )
                    : SizedBox.shrink(),
              ],
            ),
          ),
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

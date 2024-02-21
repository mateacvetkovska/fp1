import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../database/database_helper.dart';
import '../models/Order.dart';
import 'food_delivery_home_page.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  List<Order> userOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchUserOrders();
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FoodDeliveryHomePage()));
  }

  Future<void> _fetchUserOrders() async {
    if (user != null) {
      List<Order> orders = await DatabaseHelper.instance.getUserOrders(user!.uid);
      setState(() {
        userOrders = orders;
      });
    }
  }

  Future<void> _cancelOrder(int orderId) async {
    await DatabaseHelper.instance.cancelOrder(orderId);
    _fetchUserOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.teal[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black45),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text(
                    '${user?.email ?? "Not logged in"}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              userOrders.isEmpty
                  ? Text('No orders found')
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: userOrders.length,
                itemBuilder: (context, index) {
                  Order order = userOrders[index];
                  return Card(
                    child: ListTile(
                      title: Text("Order #${order.id} - \$${order.totalPrice}", style: TextStyle(fontSize: 20),),
                      subtitle: Text("Date: ${order.dateTime}", style: TextStyle(fontSize: 15),),
                      trailing: IconButton(icon: Icon(Icons.cancel), onPressed: () => _cancelOrder(order.id!)),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.teal[700], onPrimary: Colors.white),
                onPressed: () => _logout(context),
                icon: Icon(Icons.logout),
                label: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

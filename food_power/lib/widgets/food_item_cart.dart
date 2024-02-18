import 'package:flutter/material.dart';
import 'package:food_power/models/item.dart';
import 'package:food_power/views/ItemDetailPage.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodItemCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String rating;
  final Item item;

  const FoodItemCard({
    Key? key,
    required this.image,
    required this.title,
    required this.price,
    required this.rating,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailPage(item: item),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Image.asset(image, height: 100),
              Text(title, style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(color: Colors.black, letterSpacing: .5, fontSize: 20, fontWeight: FontWeight.bold,),)),
              Text(price, style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(color: Colors.black, letterSpacing: .5, fontSize: 15, ),)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(Icons.star, color: Colors.amber),
                      Text(rating),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

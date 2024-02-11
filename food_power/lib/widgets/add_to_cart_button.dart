import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  final VoidCallback onAddToCart;

  const AddToCartButton({Key? key, required this.onAddToCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onAddToCart,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      child: const Text('Add to cart'),
    );
  }
}

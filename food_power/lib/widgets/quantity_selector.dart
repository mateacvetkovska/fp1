import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final String quantity;

  const QuantitySelector({
    Key? key,
    required this.onIncrease,
    required this.onDecrease,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(icon: const Icon(Icons.remove), onPressed: onDecrease),
        Text(quantity),
        IconButton(icon: const Icon(Icons.add), onPressed: onIncrease),
      ],
    );
  }
}

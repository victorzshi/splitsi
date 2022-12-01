import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    super.key,
    required this.name,
    required this.cost,
    required this.people,
  });

  final String name;
  final double cost;
  final List<String> people;

  Color convertToColor(String name) {
    final numbers = name.codeUnits;
    final sum = numbers.reduce((a, b) => a + b);

    final remainder = sum % Colors.accents.length;

    final color = Colors.accents[remainder];

    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(name),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text('\$${cost.toStringAsFixed(2)}'),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (final person in people)
                Chip(
                  avatar: CircleAvatar(
                    backgroundColor: convertToColor(person),
                    // child: Text(person[0]),
                  ),
                  label: Text(person),
                ),
            ],
          )
        ],
      ),
    );
  }
}

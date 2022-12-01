import 'package:flutter/material.dart';

import '../../models/expense.dart';

class EditExpenseScreen extends StatelessWidget {
  const EditExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit expense'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  final expense = Expense(
                    title: 'Drinks',
                    amount: 22.45,
                    people: ['Ash', 'May', 'Brock', 'Misty'],
                  );

                  Navigator.pop(context, expense);
                },
                child: const Text('Add test expense'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

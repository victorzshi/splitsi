import 'package:flutter/material.dart';

import '../../models/expense.dart';

class EditExpenseScreen extends StatefulWidget {
  const EditExpenseScreen({super.key});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final peopleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    peopleController.dispose();
    super.dispose();
  }

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
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'What should we call this expense?',
              ),
            ),
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: '3.50? Enter a valid integer or decimal.',
              ),
            ),
            TextFormField(
              controller: peopleController,
              decoration: const InputDecoration(
                labelText: 'People',
                hintText: 'Ash, Misty, Brock? Separate names using commas.',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final amount = double.parse(amountController.text);
                  final people = peopleController.text
                      .split(',')
                      .map((person) => person.trim())
                      .toList();

                  final expense = Expense(
                    title: title,
                    amount: amount,
                    people: people,
                  );

                  Navigator.pop(context, expense);
                },
                child: const Text('Add expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

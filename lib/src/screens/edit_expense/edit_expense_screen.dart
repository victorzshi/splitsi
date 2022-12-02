import 'package:flutter/material.dart';

import '../../models/expense.dart';

/// Write a new expense. Makes sure data is validated.
class EditExpenseScreen extends StatefulWidget {
  const EditExpenseScreen({super.key, required this.expense});

  final Expense expense;

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _peopleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final people = widget.expense.people;
    if (people != null && people.isNotEmpty) {
      _peopleController.text = people.join(', ');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'What is this expense?',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (text) {
                    text = text?.trim();
                    if (text == null || text.isEmpty) {
                      return 'Please enter a title.';
                    }
                    _titleController.text = text;
                    return null;
                  },
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'How much did it cost?',
                  ),
                  validator: (text) {
                    text = text?.trim();
                    if (text == null || text.isEmpty) {
                      return 'Please enter a number.';
                    }
                    text = double.tryParse(text)?.toStringAsFixed(2);
                    if (text == null) {
                      return 'Please enter a integer or decimal.';
                    }
                    if (num.parse(text) <= 0) {
                      return 'Please enter a positive non-zero value.';
                    }
                    _amountController.text = text;
                    return null;
                  },
                ),
                TextFormField(
                  controller: _peopleController,
                  decoration: const InputDecoration(
                    labelText: 'People',
                    hintText: 'Who is splitting? Separate names using commas.',
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (text) {
                    text = text?.trim();
                    if (text == null || text.isEmpty) {
                      return 'Please enter a list of names.';
                    }
                    final names = text.split(',').map((name) => name.trim());
                    if (names.any((name) => name.isEmpty)) {
                      return 'Please check all names have some text.';
                    }
                    final unique = Set.from(names);
                    if (names.length != unique.length) {
                      return 'Please check all names are unique (case-sensitive).';
                    }
                    _peopleController.text = names.join(', ');
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final code = widget.expense.code!;
                        final title = _titleController.text;
                        final amount = double.parse(_amountController.text);
                        final people =
                            _peopleController.text.split(', ').toList();
                        people.sort();

                        final expense = Expense(
                          code: code,
                          title: title,
                          amount: amount,
                          people: people,
                        );

                        Navigator.pop(context, expense);
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add expense'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

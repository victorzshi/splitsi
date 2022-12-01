import 'package:flutter/material.dart';

import '../../models/expense.dart';

class EditExpenseScreen extends StatefulWidget {
  const EditExpenseScreen({super.key});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _peopleController = TextEditingController();

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
        title: const Text('Edit expense'),
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
                    if (double.tryParse(text) == null) {
                      return 'Please enter a valid integer or decimal.';
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
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final title = _titleController.text;
                        final amount = double.parse(_amountController.text);
                        final people =
                            _peopleController.text.split(', ').toList();

                        final expense = Expense(
                          title: title,
                          amount: amount,
                          people: people,
                        );

                        Navigator.pop(context, expense);
                      }
                    },
                    child: const Text('Add expense'),
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

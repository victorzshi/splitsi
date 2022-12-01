import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/bill.dart';
import '../../models/expense.dart';
import '../../widgets/expense_card.dart';
import '../edit_expense/edit_expense_screen.dart';
import '../view_bill/view_bill_screen.dart';
import 'expense_provider.dart';

class EditBillScreen extends StatefulWidget {
  const EditBillScreen({super.key});

  static const routeName = '/bills';

  @override
  State<EditBillScreen> createState() => _CreateBillScreen();
}

class _CreateBillScreen extends State<EditBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late Future<String> _code;

  @override
  void initState() {
    super.initState();
    _code = BillService.nextCode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  List<String> _getExistingPeople(List<Expense> expenses) {
    final uniquePeople = <String>{};

    for (final expense in expenses) {
      if (expense.people != null) {
        uniquePeople.addAll(expense.people!);
      }
    }

    final people = List.from(uniquePeople);
    people.sort();

    return List.from(people);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New bill'),
      ),
      body: FutureBuilder<String>(
        future: _code,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final code = snapshot.data as String;

            return ChangeNotifierProvider(
              create: (context) => ExpenseProvider(code: code),
              child: Consumer<ExpenseProvider>(
                builder: (context, provider, child) {
                  return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                labelText: 'Title',
                                hintText: 'What is this bill?',
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
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Description (optional)',
                                hintText: 'Any other details?',
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              validator: (text) {
                                text = text?.trim();
                                if (text != null) {
                                  _descriptionController.text = text;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      for (final expense in provider.expenses)
                        ExpenseCard(expense: expense),
                      const Divider(),
                      const SizedBox(height: 8.0),
                      NewExpenseButton(
                        code: code,
                        people: _getExistingPeople(provider.expenses),
                      ),
                      const SizedBox(height: 8.0),
                      if (provider.expenses.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Confirm with user that data is finalized.

                            if (_formKey.currentState!.validate()) {
                              // final code = snapshot.data as String;
                              final timestamp =
                                  DateTime.now().toIso8601String();
                              final title = _titleController.text.isNotEmpty
                                  ? _titleController.text
                                  : null;
                              final description =
                                  _descriptionController.text.isNotEmpty
                                      ? _descriptionController.text
                                      : null;

                              final bill = Bill(
                                code: code,
                                timestamp: timestamp,
                                title: title,
                                description: description,
                              );

                              BillService.upload(bill);
                              ExpenseService.upload(provider.expenses);

                              Navigator.restorablePopAndPushNamed(
                                context,
                                '${ViewBillScreen.routeName}/$code',
                              );
                            }
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Share bill'),
                        )
                    ],
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class NewExpenseButton extends StatefulWidget {
  const NewExpenseButton({super.key, required this.code, required this.people});

  final String code;
  final List<String> people;

  @override
  State<NewExpenseButton> createState() => _NewExpenseButtonState();
}

class _NewExpenseButtonState extends State<NewExpenseButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        _navigateAndDisplayExpense(context);
      },
      icon: const Icon(Icons.add),
      label: const Text('New expense'),
    );
  }

  Future<void> _navigateAndDisplayExpense(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        // TODO: Edit existing expense.
        return EditExpenseScreen(
          expense: Expense(
            code: widget.code,
            people: widget.people,
          ),
        );
      }),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    if (result != null) {
      final expense = result as Expense;

      Provider.of<ExpenseProvider>(context, listen: false).add(expense);

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Added "${expense.title}" expense'),
        ));
    }
  }
}

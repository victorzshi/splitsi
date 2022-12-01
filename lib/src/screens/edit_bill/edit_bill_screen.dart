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
  late Future<String> _code;

  @override
  void initState() {
    super.initState();
    BillService.setTestData();
    _code = BillService.nextCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New bill'),
      ),
      body: ChangeNotifierProvider(
        create: (context) => ExpenseProvider(),
        child: Consumer<ExpenseProvider>(
          builder: (context, provider, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (final expense in provider.expenses)
                    ExpenseCard(expense: expense),
                  const NewExpenseButton(),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FutureBuilder<String>(
        future: _code,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // TODO: Show share button only if at least one expense exists.
            return ShareBillButton(code: snapshot.data as String);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class ShareBillButton extends StatelessWidget {
  const ShareBillButton({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        // TODO: Confirm with user that data is finalized.

        final timestamp = DateTime.now().toIso8601String();

        final bill = Bill(
          code: code,
          timestamp: timestamp,
        );

        BillService.upload(bill);

        // TODO: Add code to all expenses and upload.

        Navigator.restorablePopAndPushNamed(
          context,
          '${ViewBillScreen.routeName}/$code',
        );
      },
      icon: const Icon(Icons.share),
      label: const Text('Share bill'),
    );
  }
}

class NewExpenseButton extends StatefulWidget {
  const NewExpenseButton({super.key});

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
      MaterialPageRoute(builder: (context) => const EditExpenseScreen()),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    if (result != null) {
      final expense = result as Expense;

      Provider.of<ExpenseProvider>(context, listen: false).add(expense);

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Added "${expense.title}"')));
    }
  }
}

import 'package:flutter/material.dart';

import '../../models/bill.dart';
import '../../widgets/expense_card.dart';
import '../view_bill/view_bill_screen.dart';

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({super.key});

  static const routeName = '/bills';

  @override
  State<CreateBillScreen> createState() => _CreateBillScreen();
}

class _CreateBillScreen extends State<CreateBillScreen> {
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
        title: const Text('Create a bill'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          const ExpenseCard(
            name: 'Taxi',
            cost: 18,
            people: ['Ash', 'May', 'Brock', 'Misty'],
          ),
          const ExpenseCard(
            name: 'Food',
            cost: 25,
            people: ['Ash', 'May', 'Brock'],
          ),
          // TODO: Show share button only if at least one expense exists.
          FutureBuilder<String>(
            future: _code,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Confirm with user that data is finalized

                    final code = snapshot.data;
                    final timestamp = DateTime.now().toIso8601String();

                    final bill = Bill(
                      code: code,
                      timestamp: timestamp,
                    );

                    BillService.upload(bill);

                    Navigator.restorablePopAndPushNamed(
                      context,
                      '${ViewBillScreen.routeName}/$code',
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share this bill'),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Show expense dialog.
        },
        icon: const Icon(Icons.add),
        label: const Text('Add new expense'),
      ),
    );
  }
}

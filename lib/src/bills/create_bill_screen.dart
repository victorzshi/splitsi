import 'package:flutter/material.dart';
import 'package:splitsi/src/bills/view_bill_screen.dart';

import 'bill.dart';
import 'bill_service.dart';

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({super.key});

  static const routeName = '/bills';

  @override
  State<CreateBillScreen> createState() => _CreateBillScreen();
}

class _CreateBillScreen extends State<CreateBillScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a bill'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _title,
              decoration: const InputDecoration(
                hintText: 'What should we call this bill?',
                labelText: 'Title',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                hintText: 'Any details we should mention?',
                labelText: 'Description (optional)',
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.add),
            label: const Text('Add new expense'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              // TODO: Confirm with user that data is finalized

              final code = await BillService.nextCode();
              final title = _title.text.isNotEmpty ? _title.text : null;
              final description =
                  _description.text.isNotEmpty ? _description.text : null;
              final timestamp = DateTime.now().toIso8601String();

              final bill = Bill(
                code: code,
                title: title,
                description: description,
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
          ),
        ],
      ),
    );
  }
}

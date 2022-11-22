import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
              // Confirm with user that data is finalized

              // Generate unique 4-letter code
              const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
              var code = '';
              for (var i = 0; i < 4; i++) {
                final index = Random().nextInt(alphabet.length);
                code += alphabet[index];
              }
              // TODO: Check that code is unique in database
              print(code);

              // Upload data as read-only to new doc in Firebase
              await FirebaseFirestore.instance
                  .collection('bills')
                  .add(<String, dynamic>{
                'title': _title.text,
                'description': _description.text,
                'code': code,
                'timestamp': DateTime.now().toIso8601String(),
              });
            },
            icon: const Icon(Icons.share),
            label: const Text('Share this bill'),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateBillScreen extends StatelessWidget {
  const CreateBillScreen({super.key});

  static const routeName = '/bills';

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
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'What should we call this bill?',
                labelText: 'Title',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
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

              // Upload data as read-only to new doc in Firebase
              await FirebaseFirestore.instance
                  .collection('bills')
                  .add(<String, dynamic>{
                'timestamp': DateTime.now().toIso8601String(),
              });

              // Generate unique link for doc
            },
            icon: const Icon(Icons.share),
            label: const Text('Share this bill'),
          ),
        ],
      ),
    );
  }
}

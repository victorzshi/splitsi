import 'package:flutter/material.dart';

class ViewBillScreen extends StatelessWidget {
  const ViewBillScreen({super.key, required this.code});

  static const routeName = '/bills';

  final String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View a bill'),
      ),
      // TODO: Read data from database.
      body: Center(
        child: Text(code),
      ),
    );
  }
}

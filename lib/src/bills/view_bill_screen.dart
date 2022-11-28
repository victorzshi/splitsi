import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'bill.dart';

Future<Bill> fetchBill(String code) async {
  final db = FirebaseFirestore.instance;

  final query = db.collection("bills").where("code", isEqualTo: code);

  final ref = query.withConverter(
    fromFirestore: Bill.fromFirestore,
    toFirestore: (bill, options) => bill.toFirestore(),
  );

  final querySnap = await ref.get();

  if (querySnap.docs.isEmpty) {
    throw Exception('Bill not found');
  }

  if (querySnap.docs.length != 1) {
    throw Exception('Bill has non-unique code');
  }

  final bill = querySnap.docs.first.data();
  return bill;
}

class ViewBillScreen extends StatefulWidget {
  const ViewBillScreen({super.key, required this.code});

  static const routeName = '/bills';

  final String code;

  @override
  State<ViewBillScreen> createState() => _ViewBillScreenState();
}

class _ViewBillScreenState extends State<ViewBillScreen> {
  late Future<Bill> futureCity;

  @override
  void initState() {
    super.initState();
    futureCity = fetchBill(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View a bill'),
      ),
      body: FutureBuilder<Bill>(
        future: futureCity,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.title ?? 'Untitled bill');
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

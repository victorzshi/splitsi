import 'package:flutter/material.dart';

import 'bill.dart';

class ViewBillScreen extends StatefulWidget {
  const ViewBillScreen({super.key, required this.code});

  static const routeName = '/bills';

  final String code;

  @override
  State<ViewBillScreen> createState() => _ViewBillScreenState();
}

class _ViewBillScreenState extends State<ViewBillScreen> {
  late Future<Bill> futureBill;

  @override
  void initState() {
    super.initState();
    futureBill = Bill.fetch(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View a bill'),
      ),
      body: Center(
        child: FutureBuilder<Bill>(
          future: futureBill,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  Text(snapshot.data?.code ?? 'No code'),
                  Text(snapshot.data?.title ?? 'No title'),
                  Text(snapshot.data?.description ?? 'No description'),
                  Text(snapshot.data?.timestamp ?? 'No timestamp'),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

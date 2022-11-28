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
  late Future<Bill> futureCity;

  @override
  void initState() {
    super.initState();
    futureCity = Bill.fetch(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View a bill'),
      ),
      body: Center(
        child: FutureBuilder<Bill>(
          future: futureCity,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  Text(snapshot.data?.title ?? 'Untitled bill'),
                  Text(snapshot.data?.description ?? 'No description.'),
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

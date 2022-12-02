import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../screens/view_bill/view_bill_screen.dart';
import '../../widgets/copy_text.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.uid});

  final String? uid;

  static String routeName = '/history';

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<String>> _codes;

  @override
  void initState() {
    super.initState();
    _codes = AccountService.fetchCodes(widget.uid);
  }

  String _buildUrl(String code) {
    var url = Uri.base.toString();

    url = url.substring(0, url.length - HistoryScreen.routeName.length);
    url += ViewBillScreen.routeName;
    url += '/$code';

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splitsi'),
      ),
      body: FutureBuilder<List<String>>(
        future: _codes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final codes = snapshot.data as List<String>;

            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                const Center(
                  child: Text('Previous bills...'),
                ),
                for (final code in codes)
                  Center(
                    child: CopyText(text: _buildUrl(code)),
                  ),
              ],
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

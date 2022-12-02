import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../auth_provider.dart';
import '../../models/bill.dart';
import '../../models/comment.dart';
import '../../models/expense.dart';
import '../../widgets/expense_card.dart';
import 'subscription_provider.dart';

class ViewBillScreen extends StatefulWidget {
  const ViewBillScreen({super.key, required this.code});

  static const routeName = '/bills';

  final String code;

  @override
  State<ViewBillScreen> createState() => _ViewBillScreenState();
}

class _ViewBillScreenState extends State<ViewBillScreen> {
  late Future<Bill> _bill;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      BillService.setTestData();
      ExpenseService.setTestData();
      CommentService.setTestData();
    }
    _bill = BillService.fetch(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View bill'),
      ),
      body: FutureBuilder<Bill>(
        future: _bill,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final timestamp = snapshot.data?.timestamp;

            if (timestamp == null) {
              throw Exception('No timestamp');
            }

            final url = Uri.base.toString();
            final expireDate = DateTime.parse(timestamp).add(
              const Duration(days: 30),
            );
            final expireText = DateFormat.yMMMMd().format(expireDate);

            return ListView(
              children: [
                Column(
                  children: <Widget>[
                    const Text('Share the link below:'),
                    Tooltip(
                      message: 'Click to copy!',
                      child: TextButton(
                        onPressed: () async {
                          Clipboard.setData(ClipboardData(text: url));

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied!'),
                            ),
                          );
                        },
                        child: Text(url),
                      ),
                    ),
                    Text('Expires: $expireText'),
                    const Divider(),
                    Text(snapshot.data?.title ?? 'No title'),
                    if (snapshot.data?.description != null)
                      Text(snapshot.data!.description!),
                    const Divider(),
                  ],
                ),
                ChangeNotifierProvider(
                  create: (context) => SubscriptionProvider(code: widget.code),
                  child: Consumer<SubscriptionProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        children: [
                          SplitResults(expenses: provider.expenses),
                          const Divider(),
                          for (final expense in provider.expenses)
                            ExpenseCard(expense: expense),
                          const Divider(),
                          CommentListView(
                            code: widget.code,
                            comments: provider.comments,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class SplitResults extends StatelessWidget {
  const SplitResults({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    final map = <String, double>{};

    final people = ExpenseService.getAllPeople(expenses);
    for (final person in people) {
      map.putIfAbsent(person, () => 0.0);
    }

    for (final expense in expenses) {
      for (final person in expense.people!) {
        if (map.containsKey(person)) {
          final split = expense.amount! / expense.people!.length;
          map[person] = map[person]! + split;
        }
      }
    }

    return Column(
      children: <Widget>[
        const Text('Split Results'),
        Wrap(
          children: [
            for (final item in map.entries)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 2.0,
                    ),
                    child: Chip(
                      avatar: CircleAvatar(
                        backgroundColor:
                            ExpenseService.convertToColor(item.key),
                      ),
                      label: Text(item.key),
                    ),
                  ),
                  Text('\$${item.value.toStringAsFixed(2)}'),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class CommentListView extends StatefulWidget {
  const CommentListView({
    super.key,
    required this.code,
    required this.comments,
  });

  final String code;
  final List<Comment> comments;

  @override
  State<CommentListView> createState() => _CommentListViewState();
}

class _CommentListViewState extends State<CommentListView> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'Leave a comment',
                      hintText: 'Paid already? Billing mistake? Say something!',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (text) {
                      text = text?.trim();
                      if (text == null || text.isEmpty) {
                        return 'Enter a message to continue.';
                      }
                      _commentController.text = text;
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final code = widget.code;
                      final timestamp = DateTime.now().toIso8601String();
                      final name =
                          Provider.of<AuthProvider>(context, listen: false)
                              .name;
                      final text = _commentController.text;

                      final comment = Comment(
                        code: code,
                        name: name,
                        timestamp: timestamp,
                        text: text,
                      );

                      CommentService.upload(comment);

                      _commentController.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Send'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (final comment in widget.comments) CommentTile(comment: comment),
        const SizedBox(height: 8),
      ],
    );
  }
}

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final title = '${comment.name ?? 'Anonymous'}: ${comment.text ?? ''}';
    final subtitle = DateFormat.yMMMMd()
        .add_jm()
        .format(DateTime.parse(comment.timestamp ?? ''));

    return ListTile(
      leading: const FlutterLogo(size: 32.0),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

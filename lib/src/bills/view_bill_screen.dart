import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'comments_observable.dart';
import 'bill.dart';
import 'bill_service.dart';

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
    _bill = BillService.fetch(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View a bill'),
      ),
      body: Center(
        child: FutureBuilder<Bill>(
          future: _bill,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  Text(snapshot.data?.code ?? 'No code'),
                  Text(snapshot.data?.title ?? 'No title'),
                  Text(snapshot.data?.description ?? 'No description'),
                  Text(snapshot.data?.timestamp ?? 'No timestamp'),
                  ChangeNotifierProvider(
                    create: (context) => CommentsObservable(),
                    child: Consumer<CommentsObservable>(
                      builder: (context, comments, child) {
                        return Comments(comments: comments.comments);
                      },
                    ),
                  ),
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

class Comments extends StatefulWidget {
  const Comments({super.key, required this.comments});

  final List<Comment> comments;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

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
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Leave a message',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your message to continue';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      FirebaseFirestore.instance
                          .collection('comments')
                          .add(<String, dynamic>{
                        'name': 'Anonymous',
                        'text': _controller.text,
                        'timestamp': DateTime.now().toIso8601String(),
                      });
                      _controller.clear();
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
        for (final comment in widget.comments)
          Text(
              '${DateFormat.yMMMMd().add_jm().format(DateTime.parse(comment.timestamp ?? ''))} ${comment.name}: ${comment.text}'),
        const SizedBox(height: 8),
      ],
    );
  }
}

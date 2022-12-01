import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/bill.dart';
import '../../models/comment.dart';
import 'comment_provider.dart';

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
    CommentService.setTestData();
    _bill = BillService.fetch(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View a bill'),
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
            final expiration =
                DateTime.parse(timestamp).add(const Duration(days: 30));

            return Card(
              margin: const EdgeInsets.all(32.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Text('Expires: ${DateFormat.yMMMMd().format(expiration)}'),
                    Text(snapshot.data?.title ?? 'No title'),
                    Text(snapshot.data?.description ?? 'No description'),
                    // TODO: Show expenses.
                    const Text('Expenses placeholder'),
                    ChangeNotifierProvider(
                      create: (context) => CommentProvider(code: widget.code),
                      child: Consumer<CommentProvider>(
                        builder: (context, provider, child) {
                          return CommentListView(
                            code: widget.code,
                            comments: provider.comments,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const CircularProgressIndicator();
        },
      ),
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
              mainAxisSize: MainAxisSize.min,
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
                      final comment = Comment(
                        code: widget.code,
                        timestamp: DateTime.now().toIso8601String(),
                        text: _controller.text,
                      );

                      CommentService.upload(comment);

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

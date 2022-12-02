import 'package:cloud_firestore/cloud_firestore.dart';

/// Anonymous and registered users can leave comments. Must be associated with
/// a bill. Timestamp is used to order comments by most recent/oldest.
class Comment {
  Comment({
    this.code,
    this.timestamp,
    this.name,
    this.text,
  });

  final String? code;
  final String? timestamp;
  final String? name;
  final String? text;

  factory Comment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Comment(
      code: data?['code'],
      timestamp: data?['timestamp'],
      name: data?['name'],
      text: data?['text'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (code != null) 'code': code,
      if (timestamp != null) 'timestamp': timestamp,
      if (name != null) 'name': name,
      if (text != null) 'text': text,
    };
  }
}

class CommentService {
  static final collection =
      FirebaseFirestore.instance.collection('comments').withConverter(
            fromFirestore: Comment.fromFirestore,
            toFirestore: (comment, options) => comment.toFirestore(),
          );

  static Future<void> upload(Comment comment) async {
    await collection.add(comment);
  }

  static Future<void> setTestData() async {
    const code = 'TEST';
    final query = await collection.where('code', isEqualTo: code).get();

    if (query.docs.isNotEmpty) return;

    final timestamp = DateTime.now().toIso8601String();

    final testComment = Comment(
      code: code,
      timestamp: timestamp,
      name: 'Jane Doe',
      text: 'What a cool bill!',
    );
    final anonComment = Comment(
      code: code,
      timestamp: timestamp,
      text: 'Anonymous comment...',
    );

    await collection.add(testComment);
    await collection.add(anonComment);
  }
}

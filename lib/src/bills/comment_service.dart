import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment.dart';

class CommentService {
  static final collection =
      FirebaseFirestore.instance.collection("comments").withConverter(
            fromFirestore: Comment.fromFirestore,
            toFirestore: (comment, options) => comment.toFirestore(),
          );

  static void upload(Comment comment) async {
    await collection.add(comment);
  }

  static void setTestData() async {
    final query = await collection.where("code", isEqualTo: "TEST").get();

    if (query.docs.isNotEmpty) return;

    final timestamp = DateTime.now().toIso8601String();

    final testComment = Comment(
      code: 'TEST',
      timestamp: timestamp,
      name: 'Jane Doe',
      text: 'What a cool bill!',
    );
    final anonComment = Comment(
      code: 'TEST',
      timestamp: timestamp,
      text: 'Anonymous comment...',
    );

    await collection.doc('TEST1').set(testComment);
    await collection.doc('TEST2').set(anonComment);
  }
}

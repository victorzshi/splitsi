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
}

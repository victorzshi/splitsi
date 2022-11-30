import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'comment.dart';

class CommentsObservable extends ChangeNotifier {
  CommentsObservable({required this.code}) {
    init();
  }

  final String code;

  StreamSubscription<QuerySnapshot>? _commentsSubscription;
  final List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  void init() {
    final db = FirebaseFirestore.instance;

    _commentsSubscription = db
        .collection("comments")
        .withConverter(
          fromFirestore: Comment.fromFirestore,
          toFirestore: (comment, options) => comment.toFirestore(),
        )
        .where("code", isEqualTo: code)
        .orderBy("timestamp")
        .snapshots()
        .listen((snapshot) {
      _comments.clear();

      for (final doc in snapshot.docs) {
        final comment = doc.data();
        _comments.add(comment);
      }

      notifyListeners();
    });
  }

  // TODO: Cancel comments subscription
}

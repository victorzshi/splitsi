import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Comment {
  Comment({
    this.code,
    this.name,
    this.text,
    this.timestamp,
  });

  final String? code;
  final String? name;
  final String? text;
  final String? timestamp;

  // TODO: Add Firebase methods
}

class CommentsObservable extends ChangeNotifier {
  CommentsObservable({required this.code}) {
    init();
  }

  final String code;

  StreamSubscription<QuerySnapshot>? _commentsSubscription;
  final List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  void init() {
    _commentsSubscription = FirebaseFirestore.instance
        .collection('comments')
        .where("code", isEqualTo: code)
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      _comments.clear();
      for (final doc in snapshot.docs) {
        _comments.add(
          Comment(
            code: doc.data()['code'] as String,
            name: doc.data()['name'] as String,
            text: doc.data()['text'] as String,
            timestamp: doc.data()['timestamp'] as String,
          ),
        );
      }
      notifyListeners();
    });
  }

  // TODO: Cancel comments subscription
}

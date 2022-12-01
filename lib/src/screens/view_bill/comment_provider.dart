import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/comment.dart';

class CommentProvider extends ChangeNotifier {
  CommentProvider({required this.code}) {
    init();
  }

  final String code;

  StreamSubscription<QuerySnapshot>? _commentsSubscription;
  List<Comment> get comments => _comments;
  final List<Comment> _comments = [];

  void init() {
    _commentsSubscription = CommentService.collection
        .where('code', isEqualTo: code)
        .orderBy('timestamp')
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

  @override
  void dispose() {
    _commentsSubscription?.cancel();
    super.dispose();
  }
}

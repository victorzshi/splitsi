import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/comment.dart';
import '../../models/expense.dart';

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionProvider({required this.code}) {
    init();
  }

  final String code;

  StreamSubscription<QuerySnapshot>? _commentsSubscription;
  List<Comment> get comments => UnmodifiableListView(_comments);
  final List<Comment> _comments = [];

  StreamSubscription<QuerySnapshot>? _expensesSubscription;
  List<Expense> get expenses => UnmodifiableListView(_expenses);
  final List<Expense> _expenses = [];

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

    _expensesSubscription = ExpenseService.collection
        .where('code', isEqualTo: code)
        .snapshots()
        .listen((snapshot) {
      _expenses.clear();

      for (final doc in snapshot.docs) {
        final expense = doc.data();
        _expenses.add(expense);
      }

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _commentsSubscription?.cancel();
    _expensesSubscription?.cancel();
    super.dispose();
  }
}

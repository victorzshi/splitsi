import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../models/expense.dart';

/// Contains list of expenses and notifies listeners of changes.
class ExpenseProvider extends ChangeNotifier {
  UnmodifiableListView<Expense> get expenses => UnmodifiableListView(_expenses);
  final List<Expense> _expenses = [];

  void add(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }
}

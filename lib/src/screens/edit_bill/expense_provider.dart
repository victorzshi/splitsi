import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  ExpenseProvider() {
    _expenses.add(Expense(
      title: 'Taxi',
      amount: 10,
      people: ['Ash', 'Misty', 'Brock'],
    ));

    _expenses.add(Expense(
      title: 'Food',
      amount: 17.50,
      people: ['Ash', 'Misty'],
    ));
  }

  final List<Expense> _expenses = [];
  UnmodifiableListView<Expense> get expenses => UnmodifiableListView(_expenses);

  void add(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }
}

import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  ExpenseProvider() {
    if (!kReleaseMode) {
      final people = ['Ash', 'Misty', 'Brock', 'May', 'Dawn', 'Gary'];

      _expenses.add(Expense(
        title: 'Taxi',
        amount: Random().nextDouble() * 100,
        people: people.sublist(Random().nextInt(people.length)),
      ));

      _expenses.add(Expense(
        title: 'Food',
        amount: Random().nextInt(100) as double,
        people: people.sublist(Random().nextInt(people.length)),
      ));

      _expenses.add(Expense(
        title: 'Drinks',
        amount: Random().nextDouble() * 100,
        people: people.sublist(Random().nextInt(people.length)),
      ));
    }
  }

  final List<Expense> _expenses = [];
  UnmodifiableListView<Expense> get expenses => UnmodifiableListView(_expenses);

  void add(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }
}

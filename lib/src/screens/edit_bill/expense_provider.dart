import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  ExpenseProvider() {
    if (kDebugMode) {
      // Generate dummy data
      final things = ['Taxi', 'Food', 'Drinks'];
      final names = ['Ash', 'Misty', 'Brock', 'May', 'Dawn', 'Gary'];

      final count = Random().nextInt(2) + 3;
      for (var i = 0; i < count; i++) {
        final title = things[Random().nextInt(things.length)];

        final amount = Random().nextDouble() * 99 + 1;

        final people = <String>[];
        for (final name in names) {
          if (Random().nextBool()) {
            people.add(name);
          }
        }
        if (people.isEmpty) people.add(names[Random().nextInt(names.length)]);

        _expenses.add(Expense(
          title: title,
          amount: amount,
          people: people,
        ));
      }
    }
  }

  UnmodifiableListView<Expense> get expenses => UnmodifiableListView(_expenses);
  final List<Expense> _expenses = [];

  void add(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  Expense({
    this.code,
    this.title,
    this.amount,
    this.people,
  });

  final String? code;
  final String? title;
  final double? amount;
  final List<String>? people;

  factory Expense.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Expense(
      code: data?['code'],
      title: data?['title'],
      amount: data?['amount'],
      people: (data?['people'] as List).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (code != null) 'code': code,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (people != null) 'people': people,
    };
  }
}

class ExpenseService {
  static final collection =
      FirebaseFirestore.instance.collection('expenses').withConverter(
            fromFirestore: Expense.fromFirestore,
            toFirestore: (expense, options) => expense.toFirestore(),
          );

  static Future<void> upload(List<Expense> expenses) async {
    for (final expense in expenses) {
      await collection.add(expense);
    }
  }

  static Future<void> setTestData() async {
    const code = 'TEST';
    final query = await collection.where('code', isEqualTo: code).get();

    if (query.docs.isNotEmpty) return;

    final firstExpense = Expense(
      code: code,
      title: 'Taxi',
      amount: 7.20,
      people: ['Ash', 'Misty', 'Brock', 'May', 'Dawn', 'Gary'],
    );
    final secondExpense = Expense(
      code: code,
      title: 'Food',
      amount: 37.93,
      people: ['Ash', 'May', 'Dawn', 'Gary'],
    );
    final thirdExpense = Expense(
      code: code,
      title: 'Drinks',
      amount: 12,
      people: ['Ash', 'Misty', 'Brock', 'May'],
    );

    await collection.add(firstExpense);
    await collection.add(secondExpense);
    await collection.add(thirdExpense);
  }
}

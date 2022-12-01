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
      people: data?['people'],
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

  static void upload(Expense expense) async {
    await collection.add(expense);
  }

  static Future<List<Expense>> fetch(String code) async {
    final query = await collection.where('code', isEqualTo: code).get();

    if (query.docs.isEmpty) {
      throw Exception('Expenses not found');
    }

    // TODO: Return list of expenses.
    return [];
  }

  static void setTestData() async {
    const code = 'TEST';
    final query = await collection.where('code', isEqualTo: code).get();

    if (query.docs.isNotEmpty) return;

    // TODO: Add test data.
  }
}

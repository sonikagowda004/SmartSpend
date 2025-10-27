import 'package:flutter_test/flutter_test.dart';
import 'package:smart_spend/controllers/transaction_controller.dart';
import 'package:smart_spend/models/transaction_model.dart';

void main() {
  test('Add transaction updates list and balance', () {
    final controller = TransactionController();

    final tx = TransactionModel(
      title: "Test Income",
      amount: 1000,
      category: "Salary",
      date: DateTime.now(),
      type: "Income", // ✅ use type, not isIncome
    );

    controller.transactions.add(tx);
    controller.calculateBalance();

    expect(controller.balance.value, 1000);
  });

  test('Expense reduces balance', () {
    final controller = TransactionController();

    final income = TransactionModel(
      title: "Test Income",
      amount: 1000,
      category: "Salary",
      date: DateTime.now(),
      type: "Income",
    );

    final expense = TransactionModel(
      title: "Test Expense",
      amount: 200,
      category: "Food",
      date: DateTime.now(),
      type: "Expense",
    );

    controller.transactions.addAll([income, expense]);
    controller.calculateBalance();

    expect(controller.balance.value, 800); // ✅ 1000 - 200
  });
}

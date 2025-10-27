import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';
import '../db/hive_boxes.dart';

class TransactionController extends GetxController {
  var transactions = <TransactionModel>[].obs;
  var balance = 0.0.obs;
  late Box<TransactionModel> box;

  @override
  void onInit() {
    super.onInit();
    box = Hive.box<TransactionModel>(Boxes.transactionBox);
    loadTransactions();

    
    box.watch().listen((_) => loadTransactions());
    Hive.box<BudgetModel>('budgets').watch().listen((_) => loadTransactions());
  }

  void loadTransactions() {
    transactions.assignAll(box.values.toList());
    calculateBalance();
  }


  void addTransaction(TransactionModel tx) {
    box.add(tx);
    loadTransactions();
  }


  void deleteTransaction(TransactionModel tx) async {
    await tx.delete();
    loadTransactions();
  }

 
  void updateTransaction(TransactionModel oldTx, TransactionModel newTx) async {
    final index = transactions.indexOf(oldTx);
    if (index != -1) {
      oldTx
        ..title = newTx.title
        ..amount = newTx.amount
        ..category = newTx.category
        ..date = newTx.date
        ..type = newTx.type;
      await oldTx.save();
      loadTransactions();
    }
  }


  void calculateBalance() {
    double income = 0;
    double expense = 0;
    for (var tx in transactions) {
      if (tx.isIncome) {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }
    balance.value = income - expense;
  }
}

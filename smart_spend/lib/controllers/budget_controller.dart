import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/budget_model.dart';
import '../db/hive_boxes.dart';

class BudgetController extends GetxController {
  var budgets = <BudgetModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBudgets();
  }

  void loadBudgets() {
    final box = Hive.box<BudgetModel>(Boxes.budgetBox);
    budgets.value = box.values.toList();
  }


  void addBudget(BudgetModel budget) {
    final box = Hive.box<BudgetModel>(Boxes.budgetBox);
    box.add(budget);
    loadBudgets();
  }

  void updateSpent(String category, double amount) {
    final box = Hive.box<BudgetModel>(Boxes.budgetBox);
    final budget = box.values.firstWhereOrNull((b) => b.category == category);
    if (budget != null) {
      budget.spent += amount;
      budget.save();
      loadBudgets();
    }
  }

  
  void resetBudgets() {
    final box = Hive.box<BudgetModel>(Boxes.budgetBox);
    for (var budget in box.values) {
      budget.spent = 0.0;
      budget.save();
    }
    loadBudgets();
  }

  void deleteBudget(BudgetModel budget) {
    budget.delete();
    loadBudgets();
  }
}


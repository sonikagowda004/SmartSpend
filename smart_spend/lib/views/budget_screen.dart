import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/budget_controller.dart';
import '../models/budget_model.dart';
import '../controllers/transaction_controller.dart'; // 👈 Added import to refresh data

class BudgetScreen extends StatelessWidget {
  final controller = Get.put(BudgetController());
  final categoryCtrl = TextEditingController();
  final limitCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Budgets"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🧾 Form fields
            TextField(
              controller: categoryCtrl,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: limitCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Limit (₹)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // 🟢 Add Budget Button
            ElevatedButton.icon(
              onPressed: () {
                if (categoryCtrl.text.isEmpty || limitCtrl.text.isEmpty) {
                  Get.snackbar("Error", "Please fill all fields");
                  return;
                }

                // Save new budget
                controller.addBudget(
                  BudgetModel(
                    category: categoryCtrl.text,
                    limit: double.tryParse(limitCtrl.text) ?? 0.0,
                  ),
                );

                // 🔄 Refresh dashboard/transactions
                Get.find<TransactionController>().loadTransactions();

                // Clear fields and show success
                categoryCtrl.clear();
                limitCtrl.clear();
                Get.snackbar("Success", "Budget added successfully!");
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Budget"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // 📋 Budgets List
            Expanded(
              child: Obx(() {
                if (controller.budgets.isEmpty) {
                  return const Center(child: Text("No budgets added yet"));
                }

                return ListView.builder(
                  itemCount: controller.budgets.length,
                  itemBuilder: (context, i) {
                    final b = controller.budgets[i];
                    final percent = (b.spent / b.limit).clamp(0.0, 1.0);
                    final color = percent >= 1
                        ? Colors.red
                        : (percent > 0.8 ? Colors.orange : Colors.teal);

                    return Card(
                      child: ListTile(
                        title: Text(b.category),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Limit: ₹${b.limit.toStringAsFixed(2)}"),
                            Text("Spent: ₹${b.spent.toStringAsFixed(2)}"),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: percent,
                              color: color,
                              backgroundColor: Colors.grey[300],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            controller.deleteBudget(b);

                            // 🔁 Refresh dashboard after deletion
                            Get.find<TransactionController>()
                                .loadTransactions();
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

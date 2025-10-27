import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_spend/utils/export_csv.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';
import 'add_transaction_screen.dart';

class TransactionScreen extends StatelessWidget {
  final controller = Get.put(TransactionController());

  TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Transactions"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => exportToCSV(controller),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddTransactionScreen()),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.transactions.isEmpty) {
            return const Center(
              child: Text(
                "No transactions yet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
          
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Current Balance",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          "₹${controller.balance.value.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        )),
                  ],
                ),
              ),

        
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.transactions.length,
                  itemBuilder: (context, i) {
                    final tx = controller.transactions[i];
                    final isIncome = tx.isIncome;
                    final color =
                        isIncome ? Colors.green : Colors.redAccent;
                    final amountPrefix = isIncome ? "+" : "-";

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: color.withOpacity(0.15),
                              radius: 25,
                              child: Icon(
                                isIncome
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: color,
                              ),
                            ),
                            const SizedBox(width: 12),
                           
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tx.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${tx.category} • ${DateFormat('dd MMM yyyy').format(tx.date)}",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                           
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "$amountPrefix₹${tx.amount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 18),
                                      onPressed: () => Get.to(
                                        () => AddTransactionScreen(
                                          existingTransaction: tx,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          size: 18, color: Colors.red),
                                      onPressed: () =>
                                          controller.deleteTransaction(tx),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

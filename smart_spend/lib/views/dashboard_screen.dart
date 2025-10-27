import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import '../controllers/transaction_controller.dart';
import '../widgets/transaction_tile.dart';
import 'transaction_screen.dart';
import 'budget_screen.dart';
import '../utils/export_csv.dart'; 

class DashboardScreen extends StatelessWidget {
  final controller = Get.put(TransactionController());

  final RxBool isDarkMode = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeData = isDarkMode.value
          ? ThemeData.dark(useMaterial3: true).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal,
                brightness: Brightness.dark,
              ),
            )
          : ThemeData.light(useMaterial3: true).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal,
                brightness: Brightness.light,
              ),
            );

      return Theme(
        data: themeData,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("SmartSpend"),
            centerTitle: true,
            actions: [
              
              Obx(() => IconButton(
                    icon: Icon(
                      isDarkMode.value
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                    ),
                    tooltip: isDarkMode.value
                        ? "Switch to Light Mode"
                        : "Switch to Dark Mode",
                    onPressed: () {
                      isDarkMode.value = !isDarkMode.value;
                      Get.changeThemeMode(
                        isDarkMode.value
                            ? ThemeMode.dark
                            : ThemeMode.light,
                      );
                    },
                  )),

              IconButton(
                icon: const Icon(Icons.download),
                tooltip: "Export Transactions as CSV",
                onPressed: () => exportToCSV(Get.find<TransactionController>()),
              ),

            
              IconButton(
                icon: const Icon(Icons.account_balance_wallet_outlined),
                tooltip: "Budgets",
                onPressed: () => Get.to(() => BudgetScreen()),
              ),
            ],
          ),

        
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              final txs = controller.transactions;
              final recent = txs.reversed.take(5).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Current Balance",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "₹${controller.balance.value.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),

             
                  if (txs.isNotEmpty)
                    SizedBox(
                      height: 150,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: controller.transactions
                                  .where((t) => t.isIncome)
                                  .fold<double>(0.0, (a, b) => a + b.amount),
                              color: Colors.green,
                              title: "Income",
                              radius: 50,
                            ),
                            PieChartSectionData(
                              value: controller.transactions
                                  .where((t) => !t.isIncome)
                                  .fold<double>(0.0, (a, b) => a + b.amount),
                              color: Colors.redAccent,
                              title: "Expense",
                              radius: 50,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const SizedBox(
                      height: 150,
                      child: Center(child: Text("No chart data yet")),
                    ),

                  const SizedBox(height: 20),

         
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.to(() => BudgetScreen()),
                      icon:
                          const Icon(Icons.account_balance_wallet_outlined),
                      label: const Text("Manage Budgets"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Recent Transactions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

         
                  Expanded(
                    child: txs.isEmpty
                        ? const Center(child: Text("No transactions yet"))
                        : ListView.builder(
                            itemCount: recent.length,
                            itemBuilder: (context, i) {
                              return TransactionTile(
                                transaction: recent[i],
                                onDelete: () =>
                                    controller.deleteTransaction(recent[i]),
                              );
                            },
                          ),
                  ),
                ],
              );
            }),
          ),

         
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => Get.to(() => TransactionScreen()),
          ),
        ),
      );
    });
  }
}

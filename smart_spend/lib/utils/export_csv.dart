import 'dart:io';
import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../controllers/transaction_controller.dart';

Future<void> exportToCSV(TransactionController controller) async {
  final rows = [
    ["Title", "Amount", "Category", "Type", "Date"]
  ];

  for (final tx in controller.transactions) {
    rows.add([
      tx.title,
      tx.amount.toString(), 
      tx.category,
      tx.type,
      tx.date.toIso8601String(),
    ]);
  }

  final csvData = const ListToCsvConverter().convert(rows);
  final dir = await getApplicationDocumentsDirectory();
  final file = File("${dir.path}/transactions.csv");
  await file.writeAsString(csvData);

  Get.snackbar("Export Successful", "Saved to ${file.path}");
}

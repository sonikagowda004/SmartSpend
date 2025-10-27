import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? existingTransaction; 
  const AddTransactionScreen({super.key, this.existingTransaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final controller = Get.find<TransactionController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _amountController;

  final List<String> categories = [
    "Food",
    "Travel",
    "Bills",
    "Shopping",
    "Salary",
    "Others"
  ];

  final List<String> types = ["Income", "Expense"];

  late String category;
  late String type;
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    final tx = widget.existingTransaction;
    _titleController = TextEditingController(text: tx?.title ?? '');
    _amountController =
        TextEditingController(text: tx != null ? tx.amount.toString() : '');
    category = (tx != null && categories.contains(tx.category))
        ? tx.category
        : 'Food';
    type = (tx != null && types.contains(tx.type)) ? tx.type : 'Expense';
    date = tx?.date ?? DateTime.now();
  }

  void saveTransaction() {
    if (!_formKey.currentState!.validate()) return;

    final tx = TransactionModel(
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      category: category,
      date: date,
      type: type,
    );

    if (widget.existingTransaction == null) {
      controller.addTransaction(tx);
    } else {
      controller.updateTransaction(widget.existingTransaction!, tx);
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, 
      appBar: AppBar(
        title: Text(widget.existingTransaction == null
            ? "Add Transaction"
            : "Edit Transaction"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, 
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "Enter title" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Amount (₹)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "Enter amount" : null,
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: category,
                  items: categories
                      .map(
                          (c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => category = v!),
                  decoration: const InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: type,
                  items: types
                      .map(
                          (t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setState(() => type = v!),
                  decoration: const InputDecoration(
                    labelText: "Type",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 14),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.existingTransaction == null
                        ? "Add Transaction"
                        : "Update Transaction",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

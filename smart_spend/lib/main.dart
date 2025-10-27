import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_spend/utils/theme_management.dart';

import 'models/transaction_model.dart';
import 'models/budget_model.dart';
import 'db/hive_boxes.dart';
import 'views/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(BudgetModelAdapter());

  
  final rawBox = await Hive.openBox(Boxes.transactionBox);


  for (var key in rawBox.keys.toList()) {
    final data = rawBox.get(key);

    try {
      
      if (data is Map && data['type'] is bool) {
        final bool oldType = data['type'];
        data['type'] = oldType ? 'Income' : 'Expense';
        await rawBox.put(key, data);
        debugPrint('✅ Migrated bool→String for key $key');
      }

      
      else if (data is TransactionModel && data.type is! String) {
        final String newType = (data.type == true) ? 'Income' : 'Expense';
        data.type = newType;
        await data.save();
        debugPrint('✅ Migrated TransactionModel $key');
      }

    } catch (e) {
      debugPrint('⚠️ Deleting corrupted entry $key: $e');
      await rawBox.delete(key);
    }
  }

  await rawBox.close();

 
  await Hive.openBox<TransactionModel>(Boxes.transactionBox);
  await Hive.openBox<BudgetModel>('budgets');

  final themeController = Get.put(ThemeController());

runApp(
  Obx(() => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: DashboardScreen(),
        theme: ThemeData(colorSchemeSeed: Colors.teal, brightness: Brightness.light),
        darkTheme: ThemeData.dark(),
        themeMode: themeController.themeMode,
      )),


  );
}

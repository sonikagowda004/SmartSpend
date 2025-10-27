import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smart_spend/views/dashboard_screen.dart';
import 'package:smart_spend/controllers/transaction_controller.dart';

void main() {
  testWidgets('Dashboard shows balance and transactions', (tester) async {
    Get.put(TransactionController());
    await tester.pumpWidget(GetMaterialApp(home: DashboardScreen()));

    expect(find.text("Balance"), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);
  });
}

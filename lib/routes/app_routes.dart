import 'package:flutter/material.dart';
import '../presentation/grocery_lists_dashboard/grocery_lists_dashboard.dart';
import '../presentation/grocery_list_detail/grocery_list_detail.dart';
import '../presentation/barcode_scanner/barcode_scanner.dart';
import '../presentation/profile_settings/profile_settings.dart';
import '../presentation/receipt_scanner/receipt_scanner.dart';
import '../presentation/budget_tracker/budget_tracker.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String groceryListsDashboard = '/grocery-lists-dashboard';
  static const String groceryListDetail = '/grocery-list-detail';
  static const String barcodeScanner = '/barcode-scanner';
  static const String profileSettings = '/profile-settings';
  static const String receiptScanner = '/receipt-scanner';
  static const String budgetTracker = '/budget-tracker';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const GroceryListsDashboard(),
    groceryListsDashboard: (context) => const GroceryListsDashboard(),
    groceryListDetail: (context) => const GroceryListDetail(),
    barcodeScanner: (context) => const BarcodeScanner(),
    profileSettings: (context) => const ProfileSettings(),
    receiptScanner: (context) => const ReceiptScanner(),
    budgetTracker: (context) => const BudgetTracker(),
    // TODO: Add your other routes here
  };
}

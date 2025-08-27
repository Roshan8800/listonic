import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/budget_overview_card.dart';
import './widgets/budget_settings_card.dart';
import './widgets/comparison_metrics_card.dart';
import './widgets/recent_transactions_list.dart';
import './widgets/savings_insights_card.dart';
import './widgets/spending_breakdown_chart.dart';

class BudgetTracker extends StatefulWidget {
  const BudgetTracker({Key? key}) : super(key: key);

  @override
  State<BudgetTracker> createState() => _BudgetTrackerState();
}

class _BudgetTrackerState extends State<BudgetTracker>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isMonthlyView = true;
  double _currentBudget = 800.0;

  // Mock data for budget tracking
  final List<Map<String, dynamic>> _categoryData = [
    {
      "name": "Groceries",
      "amount": 425.50,
      "transactions": 12,
    },
    {
      "name": "Household Items",
      "amount": 89.25,
      "transactions": 5,
    },
    {
      "name": "Personal Care",
      "amount": 67.80,
      "transactions": 3,
    },
    {
      "name": "Beverages",
      "amount": 45.30,
      "transactions": 8,
    },
    {
      "name": "Snacks",
      "amount": 32.15,
      "transactions": 6,
    },
  ];

  final List<Map<String, dynamic>> _recentTransactions = [
    {
      "id": 1,
      "storeName": "Whole Foods Market",
      "date": "Dec 26, 2025",
      "amount": 87.45,
      "savings": 12.30,
      "receiptThumbnail":
          "https://images.pexels.com/photos/4386321/pexels-photo-4386321.jpeg?auto=compress&cs=tinysrgb&w=400",
      "items": [
        {"name": "Organic Bananas", "quantity": 2, "price": 6.50},
        {"name": "Greek Yogurt", "quantity": 1, "price": 8.99},
        {"name": "Whole Grain Bread", "quantity": 1, "price": 4.25},
        {"name": "Free-Range Eggs", "quantity": 1, "price": 7.50},
        {"name": "Organic Spinach", "quantity": 1, "price": 3.99},
        {"name": "Almond Milk", "quantity": 2, "price": 11.98},
        {"name": "Chicken Breast", "quantity": 1, "price": 15.75},
        {"name": "Avocados", "quantity": 4, "price": 7.96},
        {"name": "Bell Peppers", "quantity": 3, "price": 5.85},
        {"name": "Olive Oil", "quantity": 1, "price": 12.99},
      ],
    },
    {
      "id": 2,
      "storeName": "Target",
      "date": "Dec 24, 2025",
      "amount": 156.78,
      "savings": 23.45,
      "receiptThumbnail":
          "https://images.pexels.com/photos/4386370/pexels-photo-4386370.jpeg?auto=compress&cs=tinysrgb&w=400",
      "items": [
        {"name": "Laundry Detergent", "quantity": 1, "price": 12.99},
        {"name": "Paper Towels", "quantity": 2, "price": 18.50},
        {"name": "Shampoo", "quantity": 1, "price": 8.75},
        {"name": "Toothpaste", "quantity": 2, "price": 7.98},
        {"name": "Frozen Pizza", "quantity": 3, "price": 14.97},
        {"name": "Ice Cream", "quantity": 1, "price": 6.99},
        {"name": "Cereal", "quantity": 2, "price": 9.98},
        {"name": "Milk", "quantity": 1, "price": 4.25},
        {"name": "Cheese", "quantity": 1, "price": 7.50},
        {"name": "Crackers", "quantity": 2, "price": 8.99},
      ],
    },
    {
      "id": 3,
      "storeName": "Costco",
      "date": "Dec 22, 2025",
      "amount": 234.67,
      "savings": 45.80,
      "receiptThumbnail":
          "https://images.pexels.com/photos/4386431/pexels-photo-4386431.jpeg?auto=compress&cs=tinysrgb&w=400",
      "items": [
        {"name": "Bulk Rice", "quantity": 1, "price": 18.99},
        {"name": "Ground Beef", "quantity": 3, "price": 45.75},
        {"name": "Salmon Fillets", "quantity": 2, "price": 28.50},
        {"name": "Frozen Vegetables", "quantity": 4, "price": 19.96},
        {"name": "Pasta", "quantity": 6, "price": 12.99},
        {"name": "Canned Tomatoes", "quantity": 8, "price": 15.92},
        {"name": "Olive Oil", "quantity": 2, "price": 24.98},
        {"name": "Nuts Mix", "quantity": 1, "price": 16.99},
        {"name": "Protein Bars", "quantity": 2, "price": 29.98},
        {"name": "Bottled Water", "quantity": 1, "price": 8.99},
      ],
    },
    {
      "id": 4,
      "storeName": "Trader Joe's",
      "date": "Dec 20, 2025",
      "amount": 73.25,
      "savings": 8.90,
      "receiptThumbnail":
          "https://images.pexels.com/photos/4386442/pexels-photo-4386442.jpeg?auto=compress&cs=tinysrgb&w=400",
      "items": [
        {"name": "Organic Apples", "quantity": 1, "price": 4.99},
        {"name": "Quinoa", "quantity": 1, "price": 5.99},
        {"name": "Coconut Water", "quantity": 4, "price": 7.96},
        {"name": "Dark Chocolate", "quantity": 2, "price": 5.98},
        {"name": "Hummus", "quantity": 2, "price": 6.98},
        {"name": "Pita Bread", "quantity": 1, "price": 2.99},
        {"name": "Frozen Berries", "quantity": 2, "price": 7.98},
        {"name": "Almond Butter", "quantity": 1, "price": 6.99},
        {"name": "Green Tea", "quantity": 1, "price": 3.49},
        {"name": "Kombucha", "quantity": 3, "price": 11.97},
      ],
    },
  ];

  final Map<String, dynamic> _comparisonData = {
    "currentMonth": 660.0,
    "previousMonth": 720.0,
    "currentAvgTrip": 82.5,
    "previousAvgTrip": 90.0,
    "currentTrips": 8,
    "previousTrips": 8,
    "currentSavings": 90.45,
    "previousSavings": 67.20,
  };

  final Map<String, dynamic> _savingsData = {
    "totalSavings": 90.45,
    "couponSavings": 34.20,
    "bulkSavings": 28.15,
    "comparisonSavings": 18.75,
    "discountSavings": 9.35,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.index = 3; // Set Budget tab as active
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double currentSpending = _categoryData.fold(
        0.0, (sum, item) => sum + (item['amount'] as double));

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Budget Tracker',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            decoration: BoxDecoration(
              color: (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMonthlyView = true;
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: _isMonthlyView
                          ? (isDarkMode
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Monthly',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _isMonthlyView
                                ? Colors.white
                                : (isDarkMode
                                    ? AppTheme.primaryDark
                                    : AppTheme.primaryLight),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMonthlyView = false;
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: !_isMonthlyView
                          ? (isDarkMode
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Weekly',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: !_isMonthlyView
                                ? Colors.white
                                : (isDarkMode
                                    ? AppTheme.primaryDark
                                    : AppTheme.primaryLight),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 1.h),
              BudgetOverviewCard(
                currentSpending: currentSpending,
                budgetLimit: _currentBudget,
                currentMonth:
                    _isMonthlyView ? 'December 2025' : 'Week of Dec 22-28',
              ),
              SpendingBreakdownChart(
                categoryData: _categoryData,
              ),
              RecentTransactionsList(
                transactions: _recentTransactions,
              ),
              BudgetSettingsCard(
                currentBudget: _currentBudget,
                onBudgetChanged: (newBudget) {
                  setState(() {
                    _currentBudget = newBudget;
                  });
                },
              ),
              ComparisonMetricsCard(
                comparisonData: _comparisonData,
              ),
              SavingsInsightsCard(
                savingsData: _savingsData,
              ),
              SizedBox(height: 10.h), // Space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? AppTheme.shadowDark : AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 3, // Budget tab active
          selectedItemColor:
              isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
          unselectedItemColor: isDarkMode
              ? AppTheme.textMediumEmphasisDark
              : AppTheme.textMediumEmphasisLight,
          backgroundColor:
              isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
          elevation: 0,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/grocery-lists-dashboard');
                break;
              case 1:
                Navigator.pushNamed(context, '/barcode-scanner');
                break;
              case 2:
                Navigator.pushNamed(context, '/receipt-scanner');
                break;
              case 3:
                // Current screen - Budget Tracker
                break;
              case 4:
                Navigator.pushNamed(context, '/profile-settings');
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'list_alt',
                color: isDarkMode
                    ? AppTheme.textMediumEmphasisDark
                    : AppTheme.textMediumEmphasisLight,
                size: 6.w,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'list_alt',
                color:
                    isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 6.w,
              ),
              label: 'Lists',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: isDarkMode
                    ? AppTheme.textMediumEmphasisDark
                    : AppTheme.textMediumEmphasisLight,
                size: 6.w,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'qr_code_scanner',
                color:
                    isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 6.w,
              ),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'receipt_long',
                color: isDarkMode
                    ? AppTheme.textMediumEmphasisDark
                    : AppTheme.textMediumEmphasisLight,
                size: 6.w,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'receipt_long',
                color:
                    isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 6.w,
              ),
              label: 'Receipt',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'account_balance_wallet',
                color:
                    isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 6.w,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'account_balance_wallet',
                color:
                    isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 6.w,
              ),
              label: 'Budget',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'person',
                color: isDarkMode
                    ? AppTheme.textMediumEmphasisDark
                    : AppTheme.textMediumEmphasisLight,
                size: 6.w,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'person',
                color:
                    isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 6.w,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would fetch updated data from the server
    setState(() {
      // Refresh data here
    });
  }
}

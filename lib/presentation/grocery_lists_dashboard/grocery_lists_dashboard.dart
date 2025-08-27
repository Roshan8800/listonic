import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_insights_banner.dart';
import './widgets/dashboard_header.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_row.dart';
import './widgets/grocery_list_card.dart';

class GroceryListsDashboard extends StatefulWidget {
  const GroceryListsDashboard({Key? key}) : super(key: key);

  @override
  State<GroceryListsDashboard> createState() => _GroceryListsDashboardState();
}

class _GroceryListsDashboardState extends State<GroceryListsDashboard>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  String _selectedFilter = 'all';
  bool _isLoading = false;
  bool _isOffline = false;
  int _selectedTabIndex = 0;

  late TabController _tabController;

  // Mock data for grocery lists
  final List<Map<String, dynamic>> _groceryLists = [
    {
      "id": 1,
      "name": "Weekly Groceries",
      "items": [
        {"name": "Organic Bananas", "completed": true},
        {"name": "Whole Milk", "completed": false},
        {"name": "Sourdough Bread", "completed": false},
        {"name": "Free-range Eggs", "completed": true},
        {"name": "Greek Yogurt", "completed": false},
      ],
      "completionPercentage": 40,
      "estimatedTotal": 67.50,
      "lastModified": DateTime.now().subtract(Duration(hours: 2)),
      "isShared": true,
      "status": "active"
    },
    {
      "id": 2,
      "name": "Party Supplies",
      "items": [
        {"name": "Chips & Dips", "completed": true},
        {"name": "Soft Drinks", "completed": true},
        {"name": "Paper Plates", "completed": true},
      ],
      "completionPercentage": 100,
      "estimatedTotal": 45.20,
      "lastModified": DateTime.now().subtract(Duration(days: 1)),
      "isShared": false,
      "status": "completed"
    },
    {
      "id": 3,
      "name": "Healthy Meal Prep",
      "items": [
        {"name": "Quinoa", "completed": false},
        {"name": "Salmon Fillets", "completed": false},
        {"name": "Broccoli", "completed": true},
        {"name": "Sweet Potatoes", "completed": false},
        {"name": "Avocados", "completed": false},
        {"name": "Olive Oil", "completed": true},
      ],
      "completionPercentage": 33,
      "estimatedTotal": 89.75,
      "lastModified": DateTime.now().subtract(Duration(hours: 6)),
      "isShared": true,
      "status": "active"
    },
    {
      "id": 4,
      "name": "Emergency Essentials",
      "items": [
        {"name": "Canned Beans", "completed": false},
        {"name": "Rice", "completed": false},
        {"name": "Pasta", "completed": false},
        {"name": "Peanut Butter", "completed": false},
      ],
      "completionPercentage": 0,
      "estimatedTotal": 32.40,
      "lastModified": DateTime.now().subtract(Duration(days: 3)),
      "isShared": false,
      "status": "active"
    },
  ];

  // Mock AI insights data
  final List<Map<String, dynamic>> _aiInsights = [
    {
      "type": "savings",
      "message": "Shop on Tuesday to save an average of \$15 this week",
      "amount": 15.0,
    },
    {
      "type": "timing",
      "message":
          "Best shopping time: Tuesday 10 AM - fewer crowds, better deals",
      "amount": 0.0,
    },
    {
      "type": "deals",
      "message": "3 items on your lists are on sale this week",
      "amount": 8.50,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _checkConnectivity();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _checkConnectivity() {
    // Simulate connectivity check
    setState(() {
      _isOffline = false; // Set to true to test offline mode
    });
  }

  Future<void> _refreshLists() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> _getFilteredLists() {
    List<Map<String, dynamic>> filtered = _groceryLists;

    // Apply filter
    switch (_selectedFilter) {
      case 'active':
        filtered =
            filtered.where((list) => list['status'] == 'active').toList();
        break;
      case 'completed':
        filtered =
            filtered.where((list) => list['status'] == 'completed').toList();
        break;
      case 'shared':
        filtered = filtered.where((list) => list['isShared'] == true).toList();
        break;
    }

    // Apply search
    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((list) => (list['name'] as String)
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  void _createNewList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create New List',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'add_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Blank List'),
              subtitle: Text('Start from scratch'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/grocery-list-detail');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'auto_awesome',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 6.w,
              ),
              title: Text('AI Suggested List'),
              subtitle: Text('Based on your shopping history'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/grocery-list-detail');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'restaurant',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w,
              ),
              title: Text('From Recipe'),
              subtitle: Text('Generate list from meal plan'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/grocery-list-detail');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleListAction(String action, Map<String, dynamic> listData) {
    switch (action) {
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sharing "${listData['name']}"')),
        );
        break;
      case 'duplicate':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Duplicated "${listData['name']}"')),
        );
        break;
      case 'archive':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Archived "${listData['name']}"')),
        );
        break;
      case 'delete':
        setState(() {
          _groceryLists.removeWhere((list) => list['id'] == listData['id']);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted "${listData['name']}"')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredLists = _getFilteredLists();
    final currentInsight = _aiInsights.isNotEmpty ? _aiInsights[0] : null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DashboardHeader(
              searchController: _searchController,
              onFilterTap: () {
                // Show filter options
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sort & Filter',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(height: 2.h),
                        ListTile(
                          leading: CustomIconWidget(
                            iconName: 'sort',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 6.w,
                          ),
                          title: Text('Sort by Date'),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          leading: CustomIconWidget(
                            iconName: 'sort_by_alpha',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 6.w,
                          ),
                          title: Text('Sort by Name'),
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
              isOffline: _isOffline,
            ),
            if (currentInsight != null)
              AiInsightsBanner(insightData: currentInsight),
            FilterChipsRow(
              selectedFilter: _selectedFilter,
              onFilterChanged: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
            ),
            Expanded(
              child: filteredLists.isEmpty
                  ? EmptyStateWidget(onCreateList: _createNewList)
                  : RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: _refreshLists,
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 10.h),
                        itemCount: filteredLists.length,
                        itemBuilder: (context, index) {
                          final listData = filteredLists[index];
                          return GroceryListCard(
                            listData: listData,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/grocery-list-detail');
                            },
                            onShare: () => _handleListAction('share', listData),
                            onDuplicate: () =>
                                _handleListAction('duplicate', listData),
                            onArchive: () =>
                                _handleListAction('archive', listData),
                            onDelete: () =>
                                _handleListAction('delete', listData),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewList,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 6.w,
        ),
        label: Text('New List'),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0, // Lists tab is active
          onTap: (index) {
            switch (index) {
              case 0:
                // Already on Lists tab
                break;
              case 1:
                Navigator.pushNamed(context, '/barcode-scanner');
                break;
              case 2:
                Navigator.pushNamed(context, '/budget-tracker');
                break;
              case 3:
                Navigator.pushNamed(context, '/profile-settings');
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'list',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              label: 'Lists',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
                size: 6.w,
              ),
              label: 'Scanner',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
                size: 6.w,
              ),
              label: 'Budget',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'person',
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
                size: 6.w,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

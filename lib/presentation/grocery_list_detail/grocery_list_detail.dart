import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_suggestions_bar.dart';
import './widgets/category_section.dart';
import './widgets/collaboration_indicator.dart';
import './widgets/list_statistics_card.dart';
import './widgets/quick_add_bar.dart';

class GroceryListDetail extends StatefulWidget {
  const GroceryListDetail({Key? key}) : super(key: key);

  @override
  State<GroceryListDetail> createState() => _GroceryListDetailState();
}

class _GroceryListDetailState extends State<GroceryListDetail>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isShoppingMode = false;
  bool _showAiSuggestions = true;
  Map<String, bool> _expandedCategories = {};

  // Mock data for the grocery list
  final Map<String, dynamic> _listData = {
    "id": 1,
    "name": "Weekly Groceries",
    "createdDate": DateTime.now().subtract(Duration(days: 2)),
    "estimatedCost": 127.50,
  };

  final List<Map<String, dynamic>> _groceryItems = [
    {
      "id": 1,
      "name": "Organic Bananas",
      "category": "Produce",
      "quantity": "2 lbs",
      "estimatedPrice": 3.99,
      "brand": "Organic Valley",
      "isCompleted": false,
      "priority": "normal",
      "note": null,
      "aisle": "1",
    },
    {
      "id": 2,
      "name": "Whole Milk",
      "category": "Dairy",
      "quantity": "1 gallon",
      "estimatedPrice": 4.29,
      "brand": "Horizon",
      "isCompleted": true,
      "priority": "high",
      "note": "Get the one with the latest expiration date",
      "aisle": "12",
    },
    {
      "id": 3,
      "name": "Ground Beef",
      "category": "Meat",
      "quantity": "1 lb",
      "estimatedPrice": 6.99,
      "brand": "Grass Fed",
      "isCompleted": false,
      "priority": "medium",
      "note": null,
      "aisle": "8",
    },
    {
      "id": 4,
      "name": "Sourdough Bread",
      "category": "Bakery",
      "quantity": "1 loaf",
      "estimatedPrice": 3.49,
      "brand": "Artisan",
      "isCompleted": false,
      "priority": "normal",
      "note": null,
      "aisle": "3",
    },
    {
      "id": 5,
      "name": "Greek Yogurt",
      "category": "Dairy",
      "quantity": "32 oz",
      "estimatedPrice": 5.99,
      "brand": "Chobani",
      "isCompleted": false,
      "priority": "normal",
      "note": "Vanilla flavor preferred",
      "aisle": "12",
    },
    {
      "id": 6,
      "name": "Fresh Spinach",
      "category": "Produce",
      "quantity": "5 oz bag",
      "estimatedPrice": 2.99,
      "brand": "Organic",
      "isCompleted": true,
      "priority": "normal",
      "note": null,
      "aisle": "1",
    },
    {
      "id": 7,
      "name": "Frozen Pizza",
      "category": "Frozen",
      "quantity": "2 pcs",
      "estimatedPrice": 8.99,
      "brand": "DiGiorno",
      "isCompleted": false,
      "priority": "low",
      "note": null,
      "aisle": "15",
    },
    {
      "id": 8,
      "name": "Olive Oil",
      "category": "Pantry",
      "quantity": "500ml",
      "estimatedPrice": 7.99,
      "brand": "Extra Virgin",
      "isCompleted": false,
      "priority": "normal",
      "note": null,
      "aisle": "5",
    },
  ];

  final List<String> _aiSuggestions = [
    "Add milk?",
    "Eggs (based on recipes)",
    "Tomatoes",
    "Cheese",
    "Onions",
  ];

  final List<Map<String, dynamic>> _activeUsers = [
    {
      "id": 1,
      "name": "Sarah Johnson",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "isActive": true,
    },
    {
      "id": 2,
      "name": "Mike Chen",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "isActive": true,
    },
  ];

  final List<Map<String, dynamic>> _recentChanges = [
    {
      "id": 1,
      "userName": "Sarah Johnson",
      "action": "Added Greek Yogurt to Dairy",
      "timestamp": DateTime.now().subtract(Duration(minutes: 5)),
    },
    {
      "id": 2,
      "userName": "Mike Chen",
      "action": "Completed Fresh Spinach",
      "timestamp": DateTime.now().subtract(Duration(minutes: 12)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeExpandedCategories();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeExpandedCategories() {
    final categories = _getCategories();
    for (String category in categories) {
      _expandedCategories[category] = true;
    }
  }

  List<String> _getCategories() {
    return _groceryItems
        .map((item) => item['category'] as String)
        .toSet()
        .toList()
      ..sort();
  }

  List<Map<String, dynamic>> _getItemsByCategory(String category) {
    List<Map<String, dynamic>> items =
        _groceryItems.where((item) => item['category'] == category).toList();

    if (_isShoppingMode) {
      // Sort by aisle number in shopping mode
      items.sort((a, b) {
        final aisleA = int.tryParse(a['aisle'] as String? ?? '0') ?? 0;
        final aisleB = int.tryParse(b['aisle'] as String? ?? '0') ?? 0;
        return aisleA.compareTo(aisleB);
      });
    } else {
      // Sort by priority and completion status
      items.sort((a, b) {
        if (a['isCompleted'] != b['isCompleted']) {
          return (a['isCompleted'] as bool) ? 1 : -1;
        }
        final priorityOrder = {'high': 0, 'medium': 1, 'normal': 2, 'low': 3};
        final priorityA = priorityOrder[a['priority']] ?? 2;
        final priorityB = priorityOrder[b['priority']] ?? 2;
        return priorityA.compareTo(priorityB);
      });
    }

    return items;
  }

  int get _totalItems => _groceryItems.length;

  int get _completedItems =>
      _groceryItems.where((item) => item['isCompleted'] == true).length;

  double get _estimatedCost => _groceryItems.fold(
      0.0, (sum, item) => sum + (item['estimatedPrice'] as double? ?? 0.0));

  void _toggleShoppingMode() {
    setState(() {
      _isShoppingMode = !_isShoppingMode;
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isShoppingMode
              ? 'Shopping mode enabled - Items organized by aisle'
              : 'Shopping mode disabled - Items organized by category',
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareList() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Share List',
                style: AppTheme.lightTheme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person_add',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Invite Collaborator'),
              subtitle: Text('Add family members or friends'),
              onTap: () {
                Navigator.pop(context);
                _showInviteDialog();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'link',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: Text('Copy Share Link'),
              subtitle: Text('Share via messaging apps'),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(
                    text: 'https://listonic.app/list/weekly-groceries-123'));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Share link copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'qr_code',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              title: Text('QR Code'),
              subtitle: Text('Let others scan to join'),
              onTap: () {
                Navigator.pop(context);
                _showQRCode();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showInviteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invite Collaborator'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email address',
                hintText: 'Enter email to invite',
                prefixIcon: CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invitation sent successfully')),
              );
            },
            child: Text('Send Invite'),
          ),
        ],
      ),
    );
  }

  void _showQRCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'qr_code',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 120,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Scan this QR code to join the list',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addItemFromSuggestion(String suggestion) {
    setState(() {
      _groceryItems.add({
        "id": _groceryItems.length + 1,
        "name": suggestion,
        "category": "Pantry", // Default category
        "quantity": "1",
        "estimatedPrice": 2.99,
        "brand": null,
        "isCompleted": false,
        "priority": "normal",
        "note": null,
        "aisle": "5",
      });
      _showAiSuggestions = false;
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$suggestion added to list')),
    );
  }

  void _addQuickItem(String itemName) {
    setState(() {
      _groceryItems.add({
        "id": _groceryItems.length + 1,
        "name": itemName,
        "category": "Pantry", // Default category
        "quantity": "1",
        "estimatedPrice": 2.99,
        "brand": null,
        "isCompleted": false,
        "priority": "normal",
        "note": null,
        "aisle": "5",
      });
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$itemName added to list')),
    );
  }

  void _onVoiceInput() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'mic',
              color: Colors.white,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Text('Listening... Say your item'),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _onBarcodeScanner() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/barcode-scanner');
  }

  void _toggleItemComplete(Map<String, dynamic> item) {
    setState(() {
      item['isCompleted'] = !(item['isCompleted'] as bool);
    });
    HapticFeedback.lightImpact();
  }

  void _editItem(Map<String, dynamic> item) {
    _showAdvancedAddModal(item: item);
  }

  void _deleteItem(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _groceryItems.remove(item);
              });
              Navigator.pop(context);
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item['name']} deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.getErrorColor(true),
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addNote(Map<String, dynamic> item) {
    final TextEditingController noteController = TextEditingController(
      text: item['note'] as String? ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Note'),
        content: TextField(
          controller: noteController,
          decoration: InputDecoration(
            labelText: 'Note for ${item['name']}',
            hintText: 'Enter your note here...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                item['note'] = noteController.text.trim().isEmpty
                    ? null
                    : noteController.text.trim();
              });
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _setPriority(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Priority'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['high', 'medium', 'normal', 'low'].map((priority) {
            return RadioListTile<String>(
              title: Text(priority.toUpperCase()),
              value: priority,
              groupValue: item['priority'] as String,
              onChanged: (value) {
                setState(() {
                  item['priority'] = value;
                });
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _findAlternatives(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Alternatives for ${item['name']}',
                style: AppTheme.lightTheme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'swap_horiz',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Generic Brand'),
              subtitle: Text('Save \$1.50 - Similar quality'),
              trailing: Text(
                  '\$${((item['estimatedPrice'] as double) - 1.50).toStringAsFixed(2)}'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Alternative suggestion noted')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'eco',
                color: AppTheme.getSuccessColor(true),
                size: 24,
              ),
              title: Text('Organic Option'),
              subtitle: Text('Premium quality - Eco-friendly'),
              trailing: Text(
                  '\$${((item['estimatedPrice'] as double) + 2.00).toStringAsFixed(2)}'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Organic alternative noted')),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showAdvancedAddModal({Map<String, dynamic>? item}) {
    final bool isEditing = item != null;
    final TextEditingController nameController = TextEditingController(
      text: isEditing ? item['name'] as String : '',
    );
    final TextEditingController quantityController = TextEditingController(
      text: isEditing ? item['quantity'] as String? ?? '' : '',
    );
    final TextEditingController brandController = TextEditingController(
      text: isEditing ? item['brand'] as String? ?? '' : '',
    );

    String selectedCategory = isEditing ? item['category'] as String : 'Pantry';
    String selectedPriority = isEditing ? item['priority'] as String : 'normal';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: 80.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  isEditing ? 'Edit Item' : 'Add New Item',
                  style: AppTheme.lightTheme.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Item Name',
                          hintText: 'Enter item name',
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: quantityController,
                              decoration: InputDecoration(
                                labelText: 'Quantity',
                                hintText: '1, 2 lbs, etc.',
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: TextField(
                              controller: brandController,
                              decoration: InputDecoration(
                                labelText: 'Brand (Optional)',
                                hintText: 'Preferred brand',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Category',
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                      ),
                      SizedBox(height: 1.h),
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: _getCategories().map((category) {
                          final isSelected = selectedCategory == category;
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedCategory = category;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme
                                        .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.lightTheme.colorScheme.outline
                                          .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                category,
                                style: AppTheme.lightTheme.textTheme.bodySmall!
                                    .copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Priority',
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children:
                            ['high', 'medium', 'normal', 'low'].map((priority) {
                          final isSelected = selectedPriority == priority;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  selectedPriority = priority;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: priority != 'low' ? 2.w : 0),
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.lightTheme.colorScheme
                                          .surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : AppTheme
                                            .lightTheme.colorScheme.outline
                                            .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  priority.toUpperCase(),
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall!
                                      .copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final name = nameController.text.trim();
                          if (name.isNotEmpty) {
                            if (isEditing) {
                              setState(() {
                                item['name'] = name;
                                item['quantity'] =
                                    quantityController.text.trim().isEmpty
                                        ? null
                                        : quantityController.text.trim();
                                item['brand'] =
                                    brandController.text.trim().isEmpty
                                        ? null
                                        : brandController.text.trim();
                                item['category'] = selectedCategory;
                                item['priority'] = selectedPriority;
                              });
                            } else {
                              setState(() {
                                _groceryItems.add({
                                  "id": _groceryItems.length + 1,
                                  "name": name,
                                  "category": selectedCategory,
                                  "quantity":
                                      quantityController.text.trim().isEmpty
                                          ? null
                                          : quantityController.text.trim(),
                                  "estimatedPrice": 2.99,
                                  "brand": brandController.text.trim().isEmpty
                                      ? null
                                      : brandController.text.trim(),
                                  "isCompleted": false,
                                  "priority": selectedPriority,
                                  "note": null,
                                  "aisle": "5",
                                });
                              });
                            }
                            Navigator.pop(context);
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isEditing
                                    ? '$name updated successfully'
                                    : '$name added to list'),
                              ),
                            );
                          }
                        },
                        child: Text(isEditing ? 'Update' : 'Add Item'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshList() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      // Update prices and availability
      for (var item in _groceryItems) {
        // Simulate price updates
        final currentPrice = item['estimatedPrice'] as double;
        final priceChange = (currentPrice * 0.1) *
            (0.5 - (DateTime.now().millisecond % 1000) / 1000);
        item['estimatedPrice'] =
            double.parse((currentPrice + priceChange).toStringAsFixed(2));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Prices and availability updated'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = _getCategories();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          _listData['name'] as String,
          style: AppTheme.lightTheme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _toggleShoppingMode,
            icon: CustomIconWidget(
              iconName: _isShoppingMode ? 'view_list' : 'map',
              color: _isShoppingMode
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: _isShoppingMode ? 'Exit Shopping Mode' : 'Shopping Mode',
          ),
          IconButton(
            onPressed: _shareList,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Share List',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: ListStatisticsCard(
                totalItems: _totalItems,
                completedItems: _completedItems,
                estimatedCost: _estimatedCost,
                listName: _listData['name'] as String,
              ),
            ),
            if (_activeUsers.isNotEmpty || _recentChanges.isNotEmpty)
              SliverToBoxAdapter(
                child: CollaborationIndicator(
                  activeUsers: _activeUsers,
                  recentChanges: _recentChanges,
                ),
              ),
            if (_showAiSuggestions && _aiSuggestions.isNotEmpty)
              SliverToBoxAdapter(
                child: AiSuggestionsBar(
                  suggestions: _aiSuggestions,
                  onSuggestionTap: _addItemFromSuggestion,
                  onDismiss: () {
                    setState(() {
                      _showAiSuggestions = false;
                    });
                  },
                ),
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = categories[index];
                  final categoryItems = _getItemsByCategory(category);

                  return CategorySection(
                    categoryName: category,
                    items: categoryItems,
                    isExpanded: _expandedCategories[category] ?? true,
                    onToggleExpansion: () {
                      setState(() {
                        _expandedCategories[category] =
                            !(_expandedCategories[category] ?? true);
                      });
                    },
                    onItemToggleComplete: _toggleItemComplete,
                    onItemEdit: _editItem,
                    onItemDelete: _deleteItem,
                    onItemAddNote: _addNote,
                    onItemSetPriority: _setPriority,
                    onItemFindAlternatives: _findAlternatives,
                  );
                },
                childCount: categories.length,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 20.h), // Space for bottom input bar
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAdvancedAddModal(),
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        tooltip: 'Add Item',
      ),
      bottomSheet: QuickAddBar(
        onAddItem: _addQuickItem,
        onVoiceInput: _onVoiceInput,
        onBarcodeScanner: _onBarcodeScanner,
      ),
    );
  }
}

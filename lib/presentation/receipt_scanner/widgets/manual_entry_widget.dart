import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ManualEntryWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onReceiptSubmit;
  final VoidCallback onCancel;

  const ManualEntryWidget({
    Key? key,
    required this.onReceiptSubmit,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<ManualEntryWidget> createState() => _ManualEntryWidgetState();
}

class _ManualEntryWidgetState extends State<ManualEntryWidget> {
  final _formKey = GlobalKey<FormState>();
  final _storeController = TextEditingController();
  final _dateController = TextEditingController();
  final _totalController = TextEditingController();

  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateTime.now().toString().split(' ')[0];
    _addNewItem();
  }

  @override
  void dispose() {
    _storeController.dispose();
    _dateController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  void _addNewItem() {
    setState(() {
      items.add({
        'name': '',
        'quantity': '1',
        'price': '',
        'category': 'Grocery',
      });
    });
  }

  void _removeItem(int index) {
    if (items.length > 1) {
      setState(() {
        items.removeAt(index);
      });
    }
  }

  void _submitReceipt() {
    if (_formKey.currentState?.validate() ?? false) {
      final receiptData = {
        'store': {
          'name': _storeController.text,
        },
        'receipt': {
          'date': _dateController.text,
          'total': '\$${_totalController.text}',
        },
        'items': items
            .where((item) => item['name'].toString().isNotEmpty)
            .map((item) => {
                  ...item,
                  'price': '\$${item['price']}',
                  'confidence': 1.0,
                  'expirationSuggestion':
                      _getExpirationSuggestion(item['category']),
                })
            .toList(),
      };

      widget.onReceiptSubmit(receiptData);
    }
  }

  String? _getExpirationSuggestion(String category) {
    final now = DateTime.now();
    switch (category.toLowerCase()) {
      case 'dairy':
        return DateTime(now.year, now.month, now.day + 7)
            .toString()
            .split(' ')[0];
      case 'produce':
        return DateTime(now.year, now.month, now.day + 5)
            .toString()
            .split(' ')[0];
      case 'meat':
        return DateTime(now.year, now.month, now.day + 3)
            .toString()
            .split(' ')[0];
      case 'frozen':
        return DateTime(now.year, now.month + 3, now.day)
            .toString()
            .split(' ')[0];
      default:
        return DateTime(now.year, now.month + 1, now.day)
            .toString()
            .split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onCancel,
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    'Manual Entry',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _submitReceipt,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Form content
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store information
                    _buildSectionHeader('Store Information'),
                    SizedBox(height: 2.h),

                    TextFormField(
                      controller: _storeController,
                      decoration: InputDecoration(
                        labelText: 'Store Name',
                        hintText: 'Enter store name',
                        prefixIcon: CustomIconWidget(
                          iconName: 'store',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter store name';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 2.h),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              labelText: 'Date',
                              hintText: 'YYYY-MM-DD',
                              prefixIcon: CustomIconWidget(
                                iconName: 'calendar_today',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 20,
                              ),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter date';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: TextFormField(
                            controller: _totalController,
                            decoration: InputDecoration(
                              labelText: 'Total Amount',
                              hintText: '0.00',
                              prefixText: '\$ ',
                              prefixIcon: CustomIconWidget(
                                iconName: 'attach_money',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 20,
                              ),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Enter total';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    // Items section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader('Items'),
                        GestureDetector(
                          onTap: _addNewItem,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'add',
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Add Item',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Items list
                    ...items.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> item = entry.value;
                      return _buildItemForm(item, index);
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  Widget _buildItemForm(Map<String, dynamic> item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Item ${index + 1}',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (items.length > 1)
                GestureDetector(
                  onTap: () => _removeItem(index),
                  child: CustomIconWidget(
                    iconName: 'delete_outline',
                    color: AppTheme.getErrorColor(true),
                    size: 20,
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          TextFormField(
            initialValue: item['name'],
            decoration: InputDecoration(
              labelText: 'Item Name',
              hintText: 'Enter item name',
            ),
            onChanged: (value) => item['name'] = value,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter item name';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: item['quantity'],
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    hintText: '1',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => item['quantity'] = value,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: item['price'],
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: '0.00',
                    prefixText: '\$ ',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) => item['price'] = value,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter price';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  value: item['category'],
                  decoration: InputDecoration(
                    labelText: 'Category',
                  ),
                  items: [
                    'Grocery',
                    'Dairy',
                    'Produce',
                    'Meat',
                    'Frozen',
                    'Bakery',
                    'Beverages',
                    'Snacks',
                    'Personal Care',
                    'Household',
                  ]
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) => item['category'] = value ?? 'Grocery',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './grocery_item_card.dart';

class CategorySection extends StatefulWidget {
  final String categoryName;
  final List<Map<String, dynamic>> items;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final Function(Map<String, dynamic>) onItemToggleComplete;
  final Function(Map<String, dynamic>) onItemEdit;
  final Function(Map<String, dynamic>) onItemDelete;
  final Function(Map<String, dynamic>) onItemAddNote;
  final Function(Map<String, dynamic>) onItemSetPriority;
  final Function(Map<String, dynamic>) onItemFindAlternatives;

  const CategorySection({
    Key? key,
    required this.categoryName,
    required this.items,
    required this.isExpanded,
    required this.onToggleExpansion,
    required this.onItemToggleComplete,
    required this.onItemEdit,
    required this.onItemDelete,
    required this.onItemAddNote,
    required this.onItemSetPriority,
    required this.onItemFindAlternatives,
  }) : super(key: key);

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (widget.isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CategorySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'produce':
        return Icons.eco;
      case 'dairy':
        return Icons.local_drink;
      case 'meat':
        return Icons.set_meal;
      case 'bakery':
        return Icons.cake;
      case 'frozen':
        return Icons.ac_unit;
      case 'pantry':
        return Icons.kitchen;
      case 'snacks':
        return Icons.cookie;
      case 'beverages':
        return Icons.local_cafe;
      case 'household':
        return Icons.home;
      case 'personal care':
        return Icons.face;
      default:
        return Icons.shopping_basket;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'produce':
        return Colors.green;
      case 'dairy':
        return Colors.blue;
      case 'meat':
        return Colors.red;
      case 'bakery':
        return Colors.orange;
      case 'frozen':
        return Colors.lightBlue;
      case 'pantry':
        return Colors.brown;
      case 'snacks':
        return Colors.purple;
      case 'beverages':
        return Colors.teal;
      case 'household':
        return Colors.grey;
      case 'personal care':
        return Colors.pink;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedItems =
        widget.items.where((item) => item['isCompleted'] == true).length;
    final totalItems = widget.items.length;
    final completionPercentage =
        totalItems > 0 ? (completedItems / totalItems) : 0.0;
    final categoryColor = _getCategoryColor(widget.categoryName);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: widget.onToggleExpansion,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                  bottom: widget.isExpanded ? Radius.zero : Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: _getCategoryIcon(widget.categoryName)
                          .codePoint
                          .toString(),
                      color: categoryColor,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.categoryName,
                          style: AppTheme.lightTheme.textTheme.titleMedium!
                              .copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Text(
                              '$completedItems of $totalItems items',
                              style: AppTheme.lightTheme.textTheme.bodySmall!
                                  .copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: completionPercentage,
                                backgroundColor:
                                    categoryColor.withValues(alpha: 0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    categoryColor),
                                minHeight: 4,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '${(completionPercentage * 100).round()}%',
                              style: AppTheme.lightTheme.textTheme.labelSmall!
                                  .copyWith(
                                color: categoryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: widget.isExpanded ? 0.5 : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: widget.items.map((item) {
                return GroceryItemCard(
                  item: item,
                  onToggleComplete: () => widget.onItemToggleComplete(item),
                  onEdit: () => widget.onItemEdit(item),
                  onDelete: () => widget.onItemDelete(item),
                  onAddNote: () => widget.onItemAddNote(item),
                  onSetPriority: () => widget.onItemSetPriority(item),
                  onFindAlternatives: () => widget.onItemFindAlternatives(item),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

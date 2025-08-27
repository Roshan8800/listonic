import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GroceryItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAddNote;
  final VoidCallback? onSetPriority;
  final VoidCallback? onFindAlternatives;

  const GroceryItemCard({
    Key? key,
    required this.item,
    this.onToggleComplete,
    this.onEdit,
    this.onDelete,
    this.onAddNote,
    this.onSetPriority,
    this.onFindAlternatives,
  }) : super(key: key);

  @override
  State<GroceryItemCard> createState() => _GroceryItemCardState();
}

class _GroceryItemCardState extends State<GroceryItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _isCompleted = false;
  bool _showActions = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.item['isCompleted'] ?? false;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleComplete() {
    setState(() {
      _isCompleted = !_isCompleted;
    });
    if (_isCompleted) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    widget.onToggleComplete?.call();
  }

  void _showContextMenu() {
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
            ListTile(
              leading: CustomIconWidget(
                iconName: 'note_add',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Add Note'),
              onTap: () {
                Navigator.pop(context);
                widget.onAddNote?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'priority_high',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              title: Text('Set Priority'),
              onTap: () {
                Navigator.pop(context);
                widget.onSetPriority?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'find_replace',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: Text('Find Alternatives'),
              onTap: () {
                Navigator.pop(context);
                widget.onFindAlternatives?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final priority = widget.item['priority'] as String? ?? 'normal';
    final hasNote = widget.item['note'] != null &&
        (widget.item['note'] as String).isNotEmpty;

    return Dismissible(
      key: Key(widget.item['id'].toString()),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _toggleComplete();
          return false;
        } else {
          setState(() {
            _showActions = true;
          });
          return false;
        }
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 4.w),
        color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
        child: CustomIconWidget(
          iconName: 'check_circle',
          color: AppTheme.getSuccessColor(true),
          size: 28,
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        color: AppTheme.getErrorColor(true).withValues(alpha: 0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: widget.onEdit,
              child: Container(
                padding: EdgeInsets.all(2.w),
                margin: EdgeInsets.only(right: 2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'edit',
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            GestureDetector(
              onTap: widget.onDelete,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.getErrorColor(true),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'delete',
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onLongPress: _showContextMenu,
        child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: priority == 'high'
                      ? AppTheme.getErrorColor(true).withValues(alpha: 0.3)
                      : priority == 'medium'
                          ? AppTheme.getWarningColor(true)
                              .withValues(alpha: 0.3)
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                  width: priority != 'normal' ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _toggleComplete,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isCompleted
                                ? AppTheme.getSuccessColor(true)
                                : AppTheme.lightTheme.colorScheme.outline,
                            width: 2,
                          ),
                          color: _isCompleted
                              ? AppTheme.getSuccessColor(true)
                              : Colors.transparent,
                        ),
                        child: _isCompleted
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AnimatedDefaultTextStyle(
                                  duration: Duration(milliseconds: 200),
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyLarge!
                                      .copyWith(
                                    decoration: _isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: _isCompleted
                                        ? AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.6)
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                    fontWeight: priority == 'high'
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                  child: Text(
                                    widget.item['name'] as String,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if (priority != 'normal') ...[
                                SizedBox(width: 2.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: priority == 'high'
                                        ? AppTheme.getErrorColor(true)
                                            .withValues(alpha: 0.1)
                                        : AppTheme.getWarningColor(true)
                                            .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    priority.toUpperCase(),
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall!
                                        .copyWith(
                                      color: priority == 'high'
                                          ? AppTheme.getErrorColor(true)
                                          : AppTheme.getWarningColor(true),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                              if (hasNote) ...[
                                SizedBox(width: 2.w),
                                CustomIconWidget(
                                  iconName: 'sticky_note_2',
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              if (widget.item['quantity'] != null) ...[
                                Text(
                                  'Qty: ${widget.item['quantity']}',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodySmall!
                                      .copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                              ],
                              if (widget.item['estimatedPrice'] != null) ...[
                                Text(
                                  '\$${(widget.item['estimatedPrice'] as double).toStringAsFixed(2)}',
                                  style: AppTheme.getDataTextStyle(
                                    isLight: true,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ).copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              ],
                              Spacer(),
                              if (widget.item['brand'] != null) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme.lightTheme.colorScheme
                                        .surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    widget.item['brand'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall!
                                        .copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.8),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (hasNote) ...[
                            SizedBox(height: 1.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.tertiary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.item['note'] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall!
                                    .copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

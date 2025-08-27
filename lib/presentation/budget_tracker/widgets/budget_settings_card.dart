import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BudgetSettingsCard extends StatefulWidget {
  final double currentBudget;
  final Function(double) onBudgetChanged;

  const BudgetSettingsCard({
    Key? key,
    required this.currentBudget,
    required this.onBudgetChanged,
  }) : super(key: key);

  @override
  State<BudgetSettingsCard> createState() => _BudgetSettingsCardState();
}

class _BudgetSettingsCardState extends State<BudgetSettingsCard> {
  late double _budgetValue;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _budgetValue = widget.currentBudget;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? AppTheme.shadowDark : AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget Settings',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                child: Text(
                  _isEditing ? 'Done' : 'Edit',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? AppTheme.primaryDark
                            : AppTheme.primaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _isEditing
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Budget: \$${_budgetValue.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 2.h),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: isDarkMode
                            ? AppTheme.primaryDark
                            : AppTheme.primaryLight,
                        inactiveTrackColor: (isDarkMode
                                ? AppTheme.primaryDark
                                : AppTheme.primaryLight)
                            .withValues(alpha: 0.3),
                        thumbColor: isDarkMode
                            ? AppTheme.primaryDark
                            : AppTheme.primaryLight,
                        overlayColor: (isDarkMode
                                ? AppTheme.primaryDark
                                : AppTheme.primaryLight)
                            .withValues(alpha: 0.2),
                        valueIndicatorColor: isDarkMode
                            ? AppTheme.primaryDark
                            : AppTheme.primaryLight,
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: _budgetValue,
                        min: 100,
                        max: 2000,
                        divisions: 38,
                        label: '\$${_budgetValue.toStringAsFixed(0)}',
                        onChanged: (value) {
                          setState(() {
                            _budgetValue = value;
                          });
                        },
                        onChangeEnd: (value) {
                          widget.onBudgetChanged(value);
                        },
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$100',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDarkMode
                                        ? AppTheme.textMediumEmphasisDark
                                        : AppTheme.textMediumEmphasisLight,
                                  ),
                        ),
                        Text(
                          '\$2000',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDarkMode
                                        ? AppTheme.textMediumEmphasisDark
                                        : AppTheme.textMediumEmphasisLight,
                                  ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Budget',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDarkMode
                                        ? AppTheme.textMediumEmphasisDark
                                        : AppTheme.textMediumEmphasisLight,
                                  ),
                        ),
                        Text(
                          '\$${widget.currentBudget.toStringAsFixed(0)}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: isDarkMode
                                        ? AppTheme.primaryDark
                                        : AppTheme.primaryLight,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  (isDarkMode ? AppTheme.tertiaryDark : AppTheme.tertiaryLight)
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (isDarkMode
                        ? AppTheme.tertiaryDark
                        : AppTheme.tertiaryLight)
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'lightbulb',
                      color: isDarkMode
                          ? AppTheme.tertiaryDark
                          : AppTheme.tertiaryLight,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'AI Recommendations',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? AppTheme.tertiaryDark
                                : AppTheme.tertiaryLight,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Based on your family size and shopping patterns, we recommend a monthly budget of \$${_getRecommendedBudget().toStringAsFixed(0)}.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode
                            ? AppTheme.textMediumEmphasisDark
                            : AppTheme.textMediumEmphasisLight,
                      ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _budgetValue = _getRecommendedBudget();
                          });
                          widget.onBudgetChanged(_budgetValue);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDarkMode
                                ? AppTheme.tertiaryDark
                                : AppTheme.tertiaryLight,
                            width: 1,
                          ),
                          foregroundColor: isDarkMode
                              ? AppTheme.tertiaryDark
                              : AppTheme.tertiaryLight,
                        ),
                        child: Text(
                          'Apply Recommendation',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getRecommendedBudget() {
    // AI-based recommendation logic (simplified)
    // In a real app, this would consider family size, location, shopping history, etc.
    return 850.0;
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BudgetOverviewCard extends StatelessWidget {
  final double currentSpending;
  final double budgetLimit;
  final String currentMonth;

  const BudgetOverviewCard({
    Key? key,
    required this.currentSpending,
    required this.budgetLimit,
    required this.currentMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percentage =
        budgetLimit > 0 ? (currentSpending / budgetLimit) : 0.0;
    final Color progressColor = _getProgressColor(percentage);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
                currentMonth,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: progressColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getBudgetStatus(percentage),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: progressColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Spending',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode
                                ? AppTheme.textMediumEmphasisDark
                                : AppTheme.textMediumEmphasisLight,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '\$${currentSpending.toStringAsFixed(2)}',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: progressColor,
                              ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Budget: \$${budgetLimit.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDarkMode
                                ? AppTheme.textMediumEmphasisDark
                                : AppTheme.textMediumEmphasisLight,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Remaining: \$${(budgetLimit - currentSpending).toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: (budgetLimit - currentSpending) >= 0
                                ? (isDarkMode
                                    ? AppTheme.successDark
                                    : AppTheme.successLight)
                                : (isDarkMode
                                    ? AppTheme.errorDark
                                    : AppTheme.errorLight),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: Stack(
                      children: [
                        CircularProgressIndicator(
                          value: percentage > 1.0 ? 1.0 : percentage,
                          strokeWidth: 8,
                          backgroundColor: (isDarkMode
                                  ? AppTheme.outlineDark
                                  : AppTheme.outlineLight)
                              .withValues(alpha: 0.3),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(progressColor),
                        ),
                        Center(
                          child: Text(
                            '${(percentage * 100).toInt()}%',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: progressColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 1.0) {
      return AppTheme.errorLight;
    } else if (percentage >= 0.8) {
      return AppTheme.warningLight;
    } else {
      return AppTheme.successLight;
    }
  }

  String _getBudgetStatus(double percentage) {
    if (percentage >= 1.0) {
      return 'Over Budget';
    } else if (percentage >= 0.8) {
      return 'Near Limit';
    } else {
      return 'On Track';
    }
  }
}

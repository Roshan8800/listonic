import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ComparisonMetricsCard extends StatelessWidget {
  final Map<String, dynamic> comparisonData;

  const ComparisonMetricsCard({
    Key? key,
    required this.comparisonData,
  }) : super(key: key);

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
          Text(
            'Month-over-Month Comparison',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  context,
                  'Total Spending',
                  comparisonData['currentMonth'] as double,
                  comparisonData['previousMonth'] as double,
                  isDarkMode,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildMetricItem(
                  context,
                  'Avg. per Trip',
                  comparisonData['currentAvgTrip'] as double,
                  comparisonData['previousAvgTrip'] as double,
                  isDarkMode,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  context,
                  'Shopping Trips',
                  (comparisonData['currentTrips'] as int).toDouble(),
                  (comparisonData['previousTrips'] as int).toDouble(),
                  isDarkMode,
                  isCount: true,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildMetricItem(
                  context,
                  'Total Savings',
                  comparisonData['currentSavings'] as double,
                  comparisonData['previousSavings'] as double,
                  isDarkMode,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight)
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
                      iconName: 'insights',
                      color: isDarkMode
                          ? AppTheme.primaryDark
                          : AppTheme.primaryLight,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Spending Insights',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? AppTheme.primaryDark
                                : AppTheme.primaryLight,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  _generateInsightText(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode
                            ? AppTheme.textMediumEmphasisDark
                            : AppTheme.textMediumEmphasisLight,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    BuildContext context,
    String title,
    double currentValue,
    double previousValue,
    bool isDarkMode, {
    bool isCount = false,
  }) {
    final double difference = currentValue - previousValue;
    final double percentageChange =
        previousValue != 0 ? (difference / previousValue) * 100 : 0;
    final bool isPositive = difference > 0;
    final bool isNeutral = difference == 0;

    Color changeColor;
    IconData changeIcon;

    if (isNeutral) {
      changeColor = isDarkMode
          ? AppTheme.textMediumEmphasisDark
          : AppTheme.textMediumEmphasisLight;
      changeIcon = Icons.remove;
    } else if (title == 'Total Savings') {
      // For savings, positive change is good
      changeColor = isPositive
          ? (isDarkMode ? AppTheme.successDark : AppTheme.successLight)
          : (isDarkMode ? AppTheme.errorDark : AppTheme.errorLight);
      changeIcon = isPositive ? Icons.trending_up : Icons.trending_down;
    } else {
      // For spending, negative change is good
      changeColor = isPositive
          ? (isDarkMode ? AppTheme.errorDark : AppTheme.errorLight)
          : (isDarkMode ? AppTheme.successDark : AppTheme.successLight);
      changeIcon = isPositive ? Icons.trending_up : Icons.trending_down;
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppTheme.surfaceVariantDark
            : AppTheme.surfaceVariantLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDarkMode ? AppTheme.outlineDark : AppTheme.outlineLight)
              .withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDarkMode
                      ? AppTheme.textMediumEmphasisDark
                      : AppTheme.textMediumEmphasisLight,
                ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Text(
            isCount
                ? currentValue.toInt().toString()
                : '\$${currentValue.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: changeIcon.codePoint.toString(),
                color: changeColor,
                size: 3.w,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  isNeutral
                      ? 'No change'
                      : '${percentageChange.abs().toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: changeColor,
                        fontWeight: FontWeight.w500,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _generateInsightText() {
    final double currentSpending = comparisonData['currentMonth'] as double;
    final double previousSpending = comparisonData['previousMonth'] as double;
    final double difference = currentSpending - previousSpending;
    final double percentageChange =
        previousSpending != 0 ? (difference / previousSpending) * 100 : 0;

    if (difference > 0) {
      return 'Your spending increased by ${percentageChange.toStringAsFixed(1)}% this month. Consider reviewing your budget categories to identify areas for optimization.';
    } else if (difference < 0) {
      return 'Great job! You reduced your spending by ${percentageChange.abs().toStringAsFixed(1)}% this month. Keep up the excellent budget management.';
    } else {
      return 'Your spending remained consistent this month. This shows good budget control and predictable shopping habits.';
    }
  }
}

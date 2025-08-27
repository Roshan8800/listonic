import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SavingsInsightsCard extends StatelessWidget {
  final Map<String, dynamic> savingsData;

  const SavingsInsightsCard({
    Key? key,
    required this.savingsData,
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
          Row(
            children: [
              CustomIconWidget(
                iconName: 'savings',
                color:
                    isDarkMode ? AppTheme.successDark : AppTheme.successLight,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Savings Insights',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: (isDarkMode ? AppTheme.successDark : AppTheme.successLight)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    (isDarkMode ? AppTheme.successDark : AppTheme.successLight)
                        .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Savings This Month',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? AppTheme.successDark
                            : AppTheme.successLight,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '\$${(savingsData['totalSavings'] as double).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDarkMode
                            ? AppTheme.successDark
                            : AppTheme.successLight,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildSavingsMetric(
                  context,
                  'Coupon Savings',
                  savingsData['couponSavings'] as double,
                  'local_offer',
                  isDarkMode,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSavingsMetric(
                  context,
                  'Bulk Buying',
                  savingsData['bulkSavings'] as double,
                  'inventory_2',
                  isDarkMode,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildSavingsMetric(
                  context,
                  'Price Comparison',
                  savingsData['comparisonSavings'] as double,
                  'compare_arrows',
                  isDarkMode,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSavingsMetric(
                  context,
                  'Store Discounts',
                  savingsData['discountSavings'] as double,
                  'percent',
                  isDarkMode,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: (isDarkMode ? AppTheme.warningDark : AppTheme.warningLight)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    (isDarkMode ? AppTheme.warningDark : AppTheme.warningLight)
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
                      iconName: 'tips_and_updates',
                      color: isDarkMode
                          ? AppTheme.warningDark
                          : AppTheme.warningLight,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Savings Opportunities',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? AppTheme.warningDark
                                : AppTheme.warningLight,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                ..._getSavingsOpportunities().map((opportunity) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 1.w,
                          height: 1.w,
                          margin: EdgeInsets.only(top: 1.5.h),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppTheme.warningDark
                                : AppTheme.warningLight,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            opportunity,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDarkMode
                                          ? AppTheme.textMediumEmphasisDark
                                          : AppTheme.textMediumEmphasisLight,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to detailed savings report
                  },
                  child: Text('View Detailed Report'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsMetric(
    BuildContext context,
    String title,
    double amount,
    String iconName,
    bool isDarkMode,
  ) {
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
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color:
                    isDarkMode ? AppTheme.successDark : AppTheme.successLight,
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode
                            ? AppTheme.textMediumEmphasisDark
                            : AppTheme.textMediumEmphasisLight,
                        fontWeight: FontWeight.w500,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color:
                      isDarkMode ? AppTheme.successDark : AppTheme.successLight,
                ),
          ),
        ],
      ),
    );
  }

  List<String> _getSavingsOpportunities() {
    return [
      'Use digital coupons for 15% more savings on household items',
      'Buy organic produce in bulk to save \$25 monthly',
      'Switch to store brand products for 20% average savings',
      'Shop during weekly sales to maximize discount opportunities',
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AiInsightsBanner extends StatelessWidget {
  final Map<String, dynamic> insightData;

  const AiInsightsBanner({
    Key? key,
    required this.insightData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final insightType = insightData['type'] ?? 'savings';
    final message = insightData['message'] ?? 'No insights available';
    final amount = insightData['amount'] ?? 0.0;
    final icon = _getInsightIcon(insightType);
    final color = _getInsightColor(insightType);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: color,
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getInsightTitle(insightType),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.8),
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (amount > 0) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    '\$${amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ],
            ),
          ),
          CustomIconWidget(
            iconName: 'chevron_right',
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            size: 5.w,
          ),
        ],
      ),
    );
  }

  String _getInsightIcon(String type) {
    switch (type) {
      case 'savings':
        return 'savings';
      case 'timing':
        return 'schedule';
      case 'budget':
        return 'account_balance_wallet';
      case 'deals':
        return 'local_offer';
      default:
        return 'lightbulb';
    }
  }

  Color _getInsightColor(String type) {
    switch (type) {
      case 'savings':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'timing':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'budget':
        return AppTheme.getWarningColor(true);
      case 'deals':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getInsightTitle(String type) {
    switch (type) {
      case 'savings':
        return 'Smart Savings';
      case 'timing':
        return 'Best Shopping Time';
      case 'budget':
        return 'Budget Alert';
      case 'deals':
        return 'Hot Deals';
      default:
        return 'AI Insight';
    }
  }
}

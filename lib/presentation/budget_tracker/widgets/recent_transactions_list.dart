import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentTransactionsList extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;

  const RecentTransactionsList({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  State<RecentTransactionsList> createState() => _RecentTransactionsListState();
}

class _RecentTransactionsListState extends State<RecentTransactionsList> {
  final Set<int> expandedTransactions = <int>{};

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
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full transaction history
                },
                child: Text(
                  'View All',
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
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.transactions.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final transaction = widget.transactions[index];
              final bool isExpanded = expandedTransactions.contains(index);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      expandedTransactions.remove(index);
                    } else {
                      expandedTransactions.add(index);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppTheme.surfaceVariantDark
                        : AppTheme.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (isDarkMode
                              ? AppTheme.outlineDark
                              : AppTheme.outlineLight)
                          .withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: (isDarkMode
                                      ? AppTheme.primaryDark
                                      : AppTheme.primaryLight)
                                  .withValues(alpha: 0.1),
                            ),
                            child: transaction['receiptThumbnail'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CustomImageWidget(
                                      imageUrl: transaction['receiptThumbnail']
                                          as String,
                                      width: 12.w,
                                      height: 12.w,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: CustomIconWidget(
                                      iconName: 'receipt',
                                      color: isDarkMode
                                          ? AppTheme.primaryDark
                                          : AppTheme.primaryLight,
                                      size: 6.w,
                                    ),
                                  ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction['storeName'] as String,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  transaction['date'] as String,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: isDarkMode
                                            ? AppTheme.textMediumEmphasisDark
                                            : AppTheme.textMediumEmphasisLight,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${(transaction['amount'] as double).toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              transaction['savings'] != null &&
                                      (transaction['savings'] as double) > 0
                                  ? Container(
                                      margin: EdgeInsets.only(top: 0.5.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 0.5.h),
                                      decoration: BoxDecoration(
                                        color: (isDarkMode
                                                ? AppTheme.successDark
                                                : AppTheme.successLight)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Saved \$${(transaction['savings'] as double).toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: isDarkMode
                                                  ? AppTheme.successDark
                                                  : AppTheme.successLight,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: isExpanded
                                ? 'keyboard_arrow_up'
                                : 'keyboard_arrow_down',
                            color: isDarkMode
                                ? AppTheme.textMediumEmphasisDark
                                : AppTheme.textMediumEmphasisLight,
                            size: 5.w,
                          ),
                        ],
                      ),
                      isExpanded
                          ? Column(
                              children: [
                                SizedBox(height: 2.h),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: (isDarkMode
                                          ? AppTheme.outlineDark
                                          : AppTheme.outlineLight)
                                      .withValues(alpha: 0.3),
                                ),
                                SizedBox(height: 2.h),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Items Purchased:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    SizedBox(height: 1.h),
                                    ...(transaction['items']
                                            as List<Map<String, dynamic>>)
                                        .map((item) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 0.5.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${item['quantity']}x ${item['name']}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              '\$${(item['price'] as double).toStringAsFixed(2)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    transaction['savings'] != null &&
                                            (transaction['savings'] as double) >
                                                0
                                        ? Container(
                                            margin: EdgeInsets.only(top: 1.h),
                                            padding: EdgeInsets.all(2.w),
                                            decoration: BoxDecoration(
                                              color: (isDarkMode
                                                      ? AppTheme.successDark
                                                      : AppTheme.successLight)
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: (isDarkMode
                                                        ? AppTheme.successDark
                                                        : AppTheme.successLight)
                                                    .withValues(alpha: 0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                CustomIconWidget(
                                                  iconName: 'savings',
                                                  color: isDarkMode
                                                      ? AppTheme.successDark
                                                      : AppTheme.successLight,
                                                  size: 4.w,
                                                ),
                                                SizedBox(width: 2.w),
                                                Expanded(
                                                  child: Text(
                                                    'You saved \$${(transaction['savings'] as double).toStringAsFixed(2)} with coupons and discounts!',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: isDarkMode
                                                              ? AppTheme
                                                                  .successDark
                                                              : AppTheme
                                                                  .successLight,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SpendingBreakdownChart extends StatefulWidget {
  final List<Map<String, dynamic>> categoryData;

  const SpendingBreakdownChart({
    Key? key,
    required this.categoryData,
  }) : super(key: key);

  @override
  State<SpendingBreakdownChart> createState() => _SpendingBreakdownChartState();
}

class _SpendingBreakdownChartState extends State<SpendingBreakdownChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double totalSpending = widget.categoryData
        .fold(0.0, (sum, item) => sum + (item['amount'] as double));

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
            'Spending Breakdown',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 25.h,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 8.w,
                      sections: _generatePieChartSections(totalSpending),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.categoryData.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final Map<String, dynamic> category = entry.value;
                      final double percentage = totalSpending > 0
                          ? (category['amount'] as double) / totalSpending * 100
                          : 0;

                      return Container(
                        margin: EdgeInsets.only(bottom: 1.h),
                        child: Row(
                          children: [
                            Container(
                              width: 3.w,
                              height: 3.w,
                              decoration: BoxDecoration(
                                color: _getCategoryColor(index),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category['name'] as String,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '\$${(category['amount'] as double).toStringAsFixed(0)} (${percentage.toInt()}%)',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: isDarkMode
                                              ? AppTheme.textMediumEmphasisDark
                                              : AppTheme
                                                  .textMediumEmphasisLight,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          touchedIndex >= 0 && touchedIndex < widget.categoryData.length
              ? Container(
                  margin: EdgeInsets.only(top: 2.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color:
                        _getCategoryColor(touchedIndex).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getCategoryColor(touchedIndex)
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.categoryData[touchedIndex]['name'] as String,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: _getCategoryColor(touchedIndex),
                                ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Amount: \$${(widget.categoryData[touchedIndex]['amount'] as double).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Transactions: ${widget.categoryData[touchedIndex]['transactions']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDarkMode
                                  ? AppTheme.textMediumEmphasisDark
                                  : AppTheme.textMediumEmphasisLight,
                            ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generatePieChartSections(double totalSpending) {
    return widget.categoryData.asMap().entries.map((entry) {
      final int index = entry.key;
      final Map<String, dynamic> category = entry.value;
      final double value = category['amount'] as double;
      final bool isTouched = index == touchedIndex;
      final double radius = isTouched ? 12.w : 10.w;

      return PieChartSectionData(
        color: _getCategoryColor(index),
        value: value,
        title: totalSpending > 0
            ? '${(value / totalSpending * 100).toInt()}%'
            : '0%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 12.sp : 10.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getCategoryColor(int index) {
    final List<Color> colors = [
      AppTheme.primaryLight,
      AppTheme.secondaryLight,
      AppTheme.tertiaryLight,
      AppTheme.successLight,
      AppTheme.warningLight,
      AppTheme.errorLight,
      AppTheme.primaryVariantLight,
      AppTheme.secondaryVariantLight,
    ];
    return colors[index % colors.length];
  }
}

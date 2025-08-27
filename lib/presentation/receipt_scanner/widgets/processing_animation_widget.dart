import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProcessingAnimationWidget extends StatefulWidget {
  final String processingText;

  const ProcessingAnimationWidget({
    Key? key,
    this.processingText = 'Analyzing receipt...',
  }) : super(key: key);

  @override
  State<ProcessingAnimationWidget> createState() =>
      _ProcessingAnimationWidgetState();
}

class _ProcessingAnimationWidgetState extends State<ProcessingAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated processing icon
            AnimatedBuilder(
              animation:
                  Listenable.merge([_rotationAnimation, _pulseAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14159,
                    child: Container(
                      width: 20.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'auto_awesome',
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 4.h),

            // Processing text
            Text(
              widget.processingText,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Progress indicator
            Container(
              width: 60.w,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // AI processing steps
            _buildProcessingSteps(),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingSteps() {
    final steps = [
      'Detecting text regions',
      'Extracting item details',
      'Analyzing prices',
      'Categorizing products',
    ];

    return Container(
      width: 70.w,
      child: Column(
        children: steps.asMap().entries.map((entry) {
          int index = entry.key;
          String step = entry.value;

          return AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              double progress = (_rotationController.value * 4) % 1;
              bool isActive =
                  progress > (index / 4) && progress < ((index + 1) / 4);

              return Container(
                margin: EdgeInsets.symmetric(vertical: 0.5.h),
                child: Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppTheme.lightTheme.primaryColor
                            : Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        step,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isActive
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.6),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

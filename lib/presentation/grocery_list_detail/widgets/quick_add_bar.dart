import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickAddBar extends StatefulWidget {
  final Function(String) onAddItem;
  final VoidCallback onVoiceInput;
  final VoidCallback onBarcodeScanner;

  const QuickAddBar({
    Key? key,
    required this.onAddItem,
    required this.onVoiceInput,
    required this.onBarcodeScanner,
  }) : super(key: key);

  @override
  State<QuickAddBar> createState() => _QuickAddBarState();
}

class _QuickAddBarState extends State<QuickAddBar> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isListening = false;

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addItem() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onAddItem(text);
      _textController.clear();
      _focusNode.unfocus();
    }
  }

  void _startVoiceInput() {
    setState(() {
      _isListening = true;
    });
    widget.onVoiceInput();
    // Simulate voice input completion after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Add item to list...',
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium!.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'add_shopping_cart',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    suffixIcon: _textController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: _addItem,
                            child: Container(
                              margin: EdgeInsets.all(1.w),
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CustomIconWidget(
                                iconName: 'send',
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          )
                        : null,
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addItem(),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: _startVoiceInput,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: _isListening
                      ? AppTheme.getErrorColor(true)
                      : AppTheme.lightTheme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: (_isListening
                              ? AppTheme.getErrorColor(true)
                              : AppTheme.lightTheme.colorScheme.secondary)
                          .withValues(alpha: 0.3),
                      blurRadius: _isListening ? 8 : 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: AnimatedScale(
                  scale: _isListening ? 1.1 : 1.0,
                  duration: Duration(milliseconds: 200),
                  child: CustomIconWidget(
                    iconName: _isListening ? 'mic' : 'mic_none',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: widget.onBarcodeScanner,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: CustomIconWidget(
                  iconName: 'qr_code_scanner',
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

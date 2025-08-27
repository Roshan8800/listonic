import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController? cameraController;
  final bool isFlashOn;
  final VoidCallback onFlashToggle;
  final VoidCallback onCapture;
  final VoidCallback onGalleryImport;

  const CameraPreviewWidget({
    Key? key,
    required this.cameraController,
    required this.isFlashOn,
    required this.onFlashToggle,
    required this.onCapture,
    required this.onGalleryImport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container(
        width: 100.w,
        height: 100.h,
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
      );
    }

    return Container(
      width: 100.w,
      height: 100.h,
      child: Stack(
        children: [
          // Camera preview
          Positioned.fill(
            child: CameraPreview(cameraController!),
          ),

          // Receipt alignment guides
          Positioned.fill(
            child: _buildReceiptGuides(),
          ),

          // Bottom toolbar
          Positioned(
            bottom: 8.h,
            left: 0,
            right: 0,
            child: _buildBottomToolbar(),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptGuides() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Corner guides
          Positioned(
            top: -1,
            left: -1,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: AppTheme.lightTheme.primaryColor, width: 4),
                  left: BorderSide(
                      color: AppTheme.lightTheme.primaryColor, width: 4),
                ),
              ),
            ),
          ),
          Positioned(
            top: -1,
            right: -1,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: AppTheme.lightTheme.primaryColor, width: 4),
                  right: BorderSide(
                      color: AppTheme.lightTheme.primaryColor, width: 4),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -1,
            left: -1,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: AppTheme.lightTheme.primaryColor, width: 4),
                  left: BorderSide(
                      color: AppTheme.lightTheme.primaryColor, width: 4),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -1,
            right: -1,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: AppTheme.lightTheme.primaryColor, width: 4),
                  right: BorderSide(
                      color: AppTheme.lightTheme.primaryColor, width: 4),
                ),
              ),
            ),
          ),

          // Center instruction text
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Align receipt within guides',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gallery import button
          GestureDetector(
            onTap: onGalleryImport,
            child: Container(
              width: 12.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'photo_library',
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          // Capture button
          GestureDetector(
            onTap: onCapture,
            child: Container(
              width: 18.w,
              height: 9.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'camera_alt',
                color: Colors.white,
                size: 32,
              ),
            ),
          ),

          // Flash toggle button (hidden on web)
          kIsWeb
              ? SizedBox(width: 12.w)
              : GestureDetector(
                  onTap: onFlashToggle,
                  child: Container(
                    width: 12.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: isFlashOn
                          ? AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.8)
                          : Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: isFlashOn ? 'flash_on' : 'flash_off',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

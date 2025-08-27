import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_preview_widget.dart';
import './widgets/manual_entry_widget.dart';
import './widgets/processing_animation_widget.dart';
import './widgets/receipt_results_widget.dart';

class ReceiptScanner extends StatefulWidget {
  const ReceiptScanner({Key? key}) : super(key: key);

  @override
  State<ReceiptScanner> createState() => _ReceiptScannerState();
}

class _ReceiptScannerState extends State<ReceiptScanner> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isFlashOn = false;
  bool _isProcessing = false;
  bool _showResults = false;
  bool _showManualEntry = false;
  XFile? _capturedImage;
  Map<String, dynamic>? _receiptData;
  final ImagePicker _imagePicker = ImagePicker();

  // Mock receipt data for demonstration
  final List<Map<String, dynamic>> _mockReceiptData = [
    {
      'store': {
        'name': 'FreshMart Grocery',
        'address': '123 Main Street, City',
      },
      'receipt': {
        'date': '2025-08-27',
        'total': '\$47.83',
        'tax': '\$3.21',
        'subtotal': '\$44.62',
      },
      'items': [
        {
          'name': 'Organic Bananas',
          'quantity': '2 lbs',
          'price': '\$3.98',
          'category': 'Produce',
          'confidence': 0.95,
          'expirationSuggestion': '2025-09-03',
        },
        {
          'name': 'Whole Milk',
          'quantity': '1 gallon',
          'price': '\$4.29',
          'category': 'Dairy',
          'confidence': 0.92,
          'expirationSuggestion': '2025-09-05',
        },
        {
          'name': 'Chicken Breast',
          'quantity': '2.5 lbs',
          'price': '\$12.47',
          'category': 'Meat',
          'confidence': 0.88,
          'expirationSuggestion': '2025-08-30',
        },
        {
          'name': 'Bread - Whole Wheat',
          'quantity': '1 loaf',
          'price': '\$2.99',
          'category': 'Bakery',
          'confidence': 0.96,
          'expirationSuggestion': '2025-09-01',
        },
        {
          'name': 'Greek Yogurt',
          'quantity': '32 oz',
          'price': '\$5.49',
          'category': 'Dairy',
          'confidence': 0.91,
          'expirationSuggestion': '2025-09-10',
        },
        {
          'name': 'Spinach - Fresh',
          'quantity': '5 oz bag',
          'price': '\$2.79',
          'category': 'Produce',
          'confidence': 0.87,
          'expirationSuggestion': '2025-08-31',
        },
        {
          'name': 'Pasta - Penne',
          'quantity': '1 lb box',
          'price': '\$1.89',
          'category': 'Grocery',
          'confidence': 0.94,
          'expirationSuggestion': '2026-08-27',
        },
        {
          'name': 'Olive Oil',
          'quantity': '16.9 fl oz',
          'price': '\$6.99',
          'category': 'Grocery',
          'confidence': 0.93,
          'expirationSuggestion': '2026-02-27',
        },
        {
          'name': 'Tomatoes - Roma',
          'quantity': '2 lbs',
          'price': '\$3.58',
          'category': 'Produce',
          'confidence': 0.89,
          'expirationSuggestion': '2025-09-02',
        },
        {
          'name': 'Cheese - Cheddar',
          'quantity': '8 oz block',
          'price': '\$3.49',
          'category': 'Dairy',
          'confidence': 0.90,
          'expirationSuggestion': '2025-09-15',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) {
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          debugPrint('Flash mode not supported: $e');
        }
      }
    } catch (e) {
      debugPrint('Camera settings error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = photo;
        _isProcessing = true;
      });

      // Simulate OCR processing
      await Future.delayed(Duration(seconds: 3));

      // Use mock data for demonstration
      final mockData = _mockReceiptData[0];

      setState(() {
        _receiptData = mockData;
        _isProcessing = false;
        _showResults = true;
      });
    } catch (e) {
      debugPrint('Photo capture error: $e');
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _importFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
          _isProcessing = true;
        });

        // Simulate OCR processing
        await Future.delayed(Duration(seconds: 3));

        // Use mock data for demonstration
        final mockData = _mockReceiptData[0];

        setState(() {
          _receiptData = mockData;
          _isProcessing = false;
          _showResults = true;
        });
      }
    } catch (e) {
      debugPrint('Gallery import error: $e');
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _toggleFlash() {
    if (kIsWeb || _cameraController == null) return;

    try {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });

      _cameraController!
          .setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    } catch (e) {
      debugPrint('Flash toggle error: $e');
    }
  }

  void _showManualEntryDialog() {
    setState(() {
      _showManualEntry = true;
    });
  }

  void _hideManualEntry() {
    setState(() {
      _showManualEntry = false;
    });
  }

  void _onManualReceiptSubmit(Map<String, dynamic> receiptData) {
    setState(() {
      _receiptData = receiptData;
      _showManualEntry = false;
      _showResults = true;
    });
  }

  void _onItemEdit(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => _buildEditItemDialog(item),
    );
  }

  Widget _buildEditItemDialog(Map<String, dynamic> item) {
    final nameController = TextEditingController(text: item['name']);
    final quantityController = TextEditingController(text: item['quantity']);
    final priceController = TextEditingController(
        text: (item['price'] as String).replaceAll('\$', ''));

    return AlertDialog(
      title: Text('Edit Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Item Name'),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: quantityController,
            decoration: InputDecoration(labelText: 'Quantity'),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'Price',
              prefixText: '\$ ',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              item['name'] = nameController.text;
              item['quantity'] = quantityController.text;
              item['price'] = '\$${priceController.text}';
            });
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  void _onAddToPantry() {
    // Navigate to pantry or show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Items added to pantry successfully!'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  void _onTrackExpenses() {
    // Navigate to budget tracker
    Navigator.pushNamed(context, '/budget-tracker');
  }

  void _resetScanner() {
    setState(() {
      _showResults = false;
      _showManualEntry = false;
      _isProcessing = false;
      _capturedImage = null;
      _receiptData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            if (_showManualEntry)
              ManualEntryWidget(
                onReceiptSubmit: _onManualReceiptSubmit,
                onCancel: _hideManualEntry,
              )
            else if (_showResults && _receiptData != null)
              ReceiptResultsWidget(
                receiptData: _receiptData!,
                onItemEdit: _onItemEdit,
                onAddToPantry: _onAddToPantry,
                onTrackExpenses: _onTrackExpenses,
                onRetake: _resetScanner,
              )
            else if (_isProcessing)
              ProcessingAnimationWidget(
                processingText: 'Analyzing receipt with AI...',
              )
            else
              _buildCameraInterface(),

            // Header overlay
            if (!_showManualEntry && !_showResults) _buildHeaderOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraInterface() {
    if (!_isInitialized) {
      return Container(
        width: 100.w,
        height: 100.h,
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(height: 2.h),
              Text(
                'Initializing camera...',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return CameraPreviewWidget(
      cameraController: _cameraController,
      isFlashOn: _isFlashOn,
      onFlashToggle: _toggleFlash,
      onCapture: _capturePhoto,
      onGalleryImport: _importFromGallery,
    );
  }

  Widget _buildHeaderOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Text(
              'Receipt Scanner',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: _showManualEntryDialog,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'edit',
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Manual',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

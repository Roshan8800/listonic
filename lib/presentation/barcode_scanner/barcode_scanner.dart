import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_preview_widget.dart';
import './widgets/list_selector_widget.dart';
import './widgets/manual_entry_widget.dart';
import './widgets/product_card_widget.dart';
import './widgets/recent_scans_widget.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({Key? key}) : super(key: key);

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isFlashOn = false;
  bool _isCameraInitialized = false;
  bool _isScanning = false;
  Map<String, dynamic>? _scannedProduct;
  String? _selectedListId;

  late AnimationController _bottomSheetController;
  late Animation<double> _bottomSheetAnimation;

  final DraggableScrollableController _scrollController =
      DraggableScrollableController();

  // Mock data for grocery lists
  final List<Map<String, dynamic>> _groceryLists = [
    {
      'id': '1',
      'name': 'Weekly Groceries',
      'icon': 'shopping_cart',
      'color': 0xFF2E7D32,
      'itemCount': 12,
    },
    {
      'id': '2',
      'name': 'Party Supplies',
      'icon': 'celebration',
      'color': 0xFF1565C0,
      'itemCount': 8,
    },
    {
      'id': '3',
      'name': 'Healthy Options',
      'icon': 'favorite',
      'color': 0xFF6A4C93,
      'itemCount': 15,
    },
  ];

  // Mock data for recent scans
  final List<Map<String, dynamic>> _recentScans = [
    {
      'id': '1',
      'name': 'Organic Bananas',
      'brand': 'Fresh Market',
      'image':
          'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=300',
      'bestPrice': '\$2.99',
      'barcode': '1234567890123',
    },
    {
      'id': '2',
      'name': 'Whole Wheat Bread',
      'brand': 'Nature\'s Own',
      'image':
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300',
      'bestPrice': '\$3.49',
      'barcode': '9876543210987',
    },
    {
      'id': '3',
      'name': 'Greek Yogurt',
      'brand': 'Chobani',
      'image':
          'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=300',
      'bestPrice': '\$4.99',
      'barcode': '5555666677778',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedListId = _groceryLists.first['id'] as String;
    _initializeAnimations();
    _initializeCamera();
  }

  void _initializeAnimations() {
    _bottomSheetController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _bottomSheetAnimation = CurvedAnimation(
      parent: _bottomSheetController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _initializeCamera() async {
    try {
      final permission = await Permission.camera.request();
      if (!permission.isGranted) {
        _showPermissionDialog();
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        Fluttertoast.showToast(msg: 'No cameras available');
        return;
      }

      final camera = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _cameraController!.setFocusMode(FocusMode.auto);

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to initialize camera');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Camera Permission Required'),
        content: Text(
          'This app needs camera access to scan barcodes. Please grant camera permission in settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      await _cameraController!.setFlashMode(
        _isFlashOn ? FlashMode.off : FlashMode.torch,
      );
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      // Flash not supported on this device
    }
  }

  void _simulateBarcodeScan(String barcode) {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
    });

    // Simulate haptic feedback
    HapticFeedback.mediumImpact();

    // Mock product data based on barcode
    final mockProduct = _getMockProductData(barcode);

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _scannedProduct = mockProduct;
          _isScanning = false;
        });
        _showProductCard();
      }
    });
  }

  Map<String, dynamic> _getMockProductData(String barcode) {
    // Mock product database
    final products = {
      '1234567890123': {
        'id': 'p1',
        'name': 'Organic Whole Milk',
        'brand': 'Horizon Organic',
        'image':
            'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',
        'barcode': barcode,
        'storePrices': [
          {'storeName': 'Walmart', 'price': '\$3.98', 'isBest': true},
          {'storeName': 'Target', 'price': '\$4.29', 'isBest': false},
          {'storeName': 'Kroger', 'price': '\$4.15', 'isBest': false},
        ],
      },
      '9876543210987': {
        'id': 'p2',
        'name': 'Cheerios Cereal',
        'brand': 'General Mills',
        'image':
            'https://images.unsplash.com/photo-1564890273409-d5c1b8b7b5b5?w=400',
        'barcode': barcode,
        'storePrices': [
          {'storeName': 'Costco', 'price': '\$5.49', 'isBest': true},
          {'storeName': 'Walmart', 'price': '\$5.98', 'isBest': false},
          {'storeName': 'Target', 'price': '\$6.29', 'isBest': false},
        ],
      },
    };

    return products[barcode] ??
        {
          'id': 'unknown',
          'name': 'Unknown Product',
          'brand': 'Generic Brand',
          'image':
              'https://images.unsplash.com/photo-1586380951230-4c5b1f2e8e8e?w=400',
          'barcode': barcode,
          'storePrices': [
            {'storeName': 'Local Store', 'price': '\$0.00', 'isBest': true},
          ],
        };
  }

  void _showProductCard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        child: Column(
          children: [
            Expanded(
              child: ProductCardWidget(
                product: _scannedProduct!,
                onAddToList: _addProductToList,
                onViewAlternatives: _showAlternatives,
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              child: ListSelectorWidget(
                groceryLists: _groceryLists,
                selectedListId: _selectedListId,
                onListSelected: (listId) {
                  setState(() {
                    _selectedListId = listId;
                  });
                },
                onCreateNewList: _createNewList,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addProductToList() {
    final selectedList = _groceryLists.firstWhere(
      (list) => list['id'] == _selectedListId,
    );

    Fluttertoast.showToast(
      msg: 'Added to ${selectedList['name']}',
      backgroundColor: AppTheme.lightTheme.primaryColor,
      textColor: Colors.white,
    );

    Navigator.pop(context);

    // Add to recent scans if not already there
    final productExists = _recentScans.any(
      (scan) => scan['barcode'] == _scannedProduct!['barcode'],
    );

    if (!productExists) {
      setState(() {
        _recentScans.insert(0, {
          'id': _scannedProduct!['id'],
          'name': _scannedProduct!['name'],
          'brand': _scannedProduct!['brand'],
          'image': _scannedProduct!['image'],
          'bestPrice': (_scannedProduct!['storePrices'] as List)
              .firstWhere((store) => store['isBest'])['price'],
          'barcode': _scannedProduct!['barcode'],
        });

        // Keep only last 10 scans
        if (_recentScans.length > 10) {
          _recentScans.removeLast();
        }
      });
    }
  }

  void _showAlternatives() {
    Fluttertoast.showToast(msg: 'Showing alternatives...');
    // Navigate to alternatives screen
  }

  void _createNewList() {
    Fluttertoast.showToast(msg: 'Create new list feature coming soon');
  }

  void _showManualEntry() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ManualEntryWidget(
          onBarcodeEntered: (barcode) {
            Navigator.pop(context);
            _simulateBarcodeScan(barcode);
          },
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _onProductTap(Map<String, dynamic> product) {
    setState(() {
      _scannedProduct = _getMockProductData(product['barcode'] as String);
    });
    _showProductCard();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _bottomSheetController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          if (_isCameraInitialized)
            CameraPreviewWidget(
              cameraController: _cameraController,
              isFlashOn: _isFlashOn,
              onFlashToggle: _toggleFlash,
              onClose: () => Navigator.pop(context),
            )
          else
            Container(
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
                      'Initializing Camera...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom draggable sheet
          DraggableScrollableSheet(
            controller: _scrollController,
            initialChildSize: 0.3,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      width: 12.w,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Manual entry button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: ElevatedButton(
                        onPressed: _showManualEntry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1),
                          foregroundColor: AppTheme.lightTheme.primaryColor,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'keyboard',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Enter Barcode Manually',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Recent scans
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: RecentScansWidget(
                          recentScans: _recentScans,
                          onProductTap: _onProductTap,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Scanning indicator
          if (_isScanning)
            Container(
              width: 100.w,
              height: 100.h,
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Scanning Product...',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),

      // Floating scan button
      floatingActionButton: _isCameraInitialized
          ? FloatingActionButton.extended(
              onPressed: () => _simulateBarcodeScan('1234567890123'),
              backgroundColor: AppTheme.lightTheme.primaryColor,
              foregroundColor: Colors.white,
              icon: CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: Colors.white,
                size: 6.w,
              ),
              label: Text(
                'Tap to Scan',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

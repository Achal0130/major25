import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool _isCapturing = false;
  File? _imageFile;
  Uint8List? _webImage;
  CameraController? _cameraController;
  List<CameraDescription> cameras = [];
  bool _isImageScanned = false;
  String _activeTab = 'Plant';
  bool _isCameraView = true;
  bool _isCameraInitialized = false;
  bool _isLoading = true;

  late AnimationController _animationController;
  late Animation<double> _scanningBarAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scanningBarAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? controller = _cameraController;

    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      _isCameraInitialized = false;
    } else if (state == AppLifecycleState.resumed && _isCameraView) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    setState(() => _isLoading = true);

    try {
      if (_cameraController != null) {
        await _cameraController!.dispose();
      }

      cameras = await availableCameras();

      if (cameras.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error initializing camera: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    if (_isCapturing) return;

    setState(() => _isCapturing = true);

    try {
      final XFile image = await _cameraController!.takePicture();

      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _webImage = bytes;
          _imageFile = null;
          _isCapturing = false;
          _isImageScanned = false;
          _isCameraView = false;
        });
      } else {
        setState(() {
          _imageFile = File(image.path);
          _webImage = null;
          _isCapturing = false;
          _isImageScanned = false;
          _isCameraView = false;
        });
      }
    } catch (e) {
      print('Error capturing image: $e');
      setState(() => _isCapturing = false);
    }
  }

  void _scanImage() async {
    if (_imageFile == null && _webImage == null) return;

    setState(() {
      _isImageScanned = true;
    });

    _animationController.repeat(reverse: true); // Start looping animation

    await Future.delayed(const Duration(seconds: 5));

    _animationController.stop();
    setState(() {
      _isImageScanned = false;
    });
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        if (kIsWeb) {
          final bytes = await pickedImage.readAsBytes();
          setState(() {
            _webImage = bytes;
            _imageFile = null;
            _isImageScanned = false;
            _isCameraView = false;
          });
        } else {
          setState(() {
            _imageFile = File(pickedImage.path);
            _webImage = null;
            _isImageScanned = false;
            _isCameraView = false;
          });
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _resetImage() async {
    setState(() {
      _imageFile = null;
      _webImage = null;
      _isImageScanned = false;
      _isCameraView = true;
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    await _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildImagePreview()),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTabButton('Plant'),
                _buildTabButton('Disease'),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tabName) {
    final isActive = _activeTab == tabName;

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = tabName;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          tabName,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;

          return Stack(
            fit: StackFit.expand,
            children: [
              if (!_isCameraView && _webImage != null && kIsWeb)
                Image.memory(_webImage!, fit: BoxFit.cover)
              else if (!_isCameraView && _imageFile != null && !kIsWeb)
                Image.file(_imageFile!, fit: BoxFit.cover)
              else if (_isCameraInitialized &&
                  _cameraController != null &&
                  _cameraController!.value.isInitialized)
                CameraPreview(_cameraController!)
              else
                const Center(
                  child: Text('Camera initializing...',
                      style: TextStyle(color: Colors.white)),
                ),
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              if (_isImageScanned)
                AnimatedBuilder(
                  animation: _scanningBarAnimation,
                  builder: (context, child) {
                    final animationValue = _scanningBarAnimation.value;
                    final barBottom = maxHeight * animationValue;
                    final overlayHeight = barBottom;

                    return Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: overlayHeight,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.4),
                                  Colors.greenAccent.withOpacity(0.4),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: barBottom - 6,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 6,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.photo_library, color: Colors.white, size: 28),
            onPressed: _getImageFromGallery,
          ),
          GestureDetector(
            onTap: _isCameraView
                ? (_isCameraInitialized ? _captureImage : null)
                : _scanImage,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isCameraView && !_isCameraInitialized
                      ? Colors.grey
                      : Colors.white,
                  width: 3,
                ),
                color: !_isCameraView ? Colors.green : Colors.transparent,
              ),
              child: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isCameraView && !_isCameraInitialized
                        ? Colors.grey
                        : Colors.white,
                  ),
                  child: _isCapturing
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Icon(
                          _isCameraView ? Icons.camera_alt : Icons.search,
                          color: Colors.black,
                          size: 30,
                        ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white, size: 28),
            onPressed: _resetImage,
          ),
        ],
      ),
    );
  }
}

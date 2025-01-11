import 'package:em_repairs/components/other_components/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ImageCaptureGrid extends StatefulWidget {
  final Function(Map<String, String?> capturedImages) onImagesCaptured;

  const ImageCaptureGrid({Key? key, required this.onImagesCaptured}) : super(key: key);

  @override
  _ImageCaptureGridState createState() => _ImageCaptureGridState();
}

class _ImageCaptureGridState extends State<ImageCaptureGrid> {
  List<CameraDescription>? cameras;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  final Map<String, String?> _capturedImages = {
    "Device Front": null,
    "Device Back": null,
    "Left Side Image": null,
    "Right Side Image": null,
  };

  @override
  void initState() {
    super.initState();
    _loadCameras();
  }

  Future<void> _loadCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        _initializeCamera(cameras!.first); // Initialize with the first camera by default
      }
    } catch (e) {
      print("Error loading cameras: $e");
    }
  }

  void _initializeCamera(CameraDescription cameraDescription) {
    _controller?.dispose(); // Dispose of the previous controller if any
    _controller = CameraController(cameraDescription, ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();
    setState(() {}); // Update the UI after initialization
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose of the controller when not in use
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return cameras == null
        ? const Center(child: CircularProgressIndicator()) // Show a loader until cameras are loaded
        : GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            padding: const EdgeInsets.all(16),
            children: [
              _buildIcon(Icons.camera_front, "Device Front", () {
                _switchAndNavigateToCameraScreen("Device Front", cameras!.first);
              }),
              _buildIcon(Icons.photo_camera_back, "Device Back", () {
                _switchAndNavigateToCameraScreen("Device Back", cameras!.last);
              }),
              _buildIcon(Icons.camera_alt_rounded, "Left Side Image", () {
                _navigateToCameraScreen("Left Side Image");
              }),
              _buildIcon(Icons.camera_alt_rounded, "Right Side Image", () {
                _navigateToCameraScreen("Right Side Image");
              }),
            ],
          );
  }

  void _switchAndNavigateToCameraScreen(String title, CameraDescription camera) {
    _initializeCamera(camera);
    _navigateToCameraScreen(title);
  }

  void _navigateToCameraScreen(String title) {
    if (_controller == null || _initializeControllerFuture == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera not initialized')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          title: title,
          controller: _controller!,
          initializeControllerFuture: _initializeControllerFuture!,
          onCapture: (imagePath) {
            _onImageCaptured(title, imagePath);
          },
        ),
      ),
    );
  }

  void _onImageCaptured(String title, String imagePath) {
    setState(() {
      _capturedImages[title] = imagePath;
    });

    // Pass captured images to parent component
    widget.onImagesCaptured(_capturedImages);
  }

  Widget _buildIcon(IconData icon, String label, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(icon, size: 48, color: Colors.teal),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:em_repairs/components/other_components/camera_screen.dart';

class ImageCaptureGrid extends StatefulWidget {
  const ImageCaptureGrid({super.key});

  @override
  _ImageCaptureGridState createState() => _ImageCaptureGridState();
}

class _ImageCaptureGridState extends State<ImageCaptureGrid> {
  late List<CameraDescription> cameras;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the available cameras
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      _initializeCamera(cameras.first);  // Initialize the first camera by default
    });
  }

  void _initializeCamera(CameraDescription cameraDescription) {
    _controller = CameraController(cameraDescription, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose(); // Always dispose the controller when not in use
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      padding: const EdgeInsets.all(16),
      children: [
        _buildIcon(Icons.camera_front, "Device Front", () {
          _navigateToCameraScreen("Device Front");
        }),
        _buildIcon(Icons.photo_camera_back, "Device Back", () {
          _navigateToCameraScreen("Device Back");
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

  // Navigate to the camera screen
  void _navigateToCameraScreen(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          title: title,
          controller: _controller,
          initializeControllerFuture: _initializeControllerFuture,
          onCapture: (context) {
            // Capture functionality (implement as per requirement)
          },
        ),
      ),
    );
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
                  offset: Offset(0, 4),
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

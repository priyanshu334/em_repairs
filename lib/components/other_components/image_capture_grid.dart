import 'dart:io';
import 'package:em_repairs/models/model_details_model.dart';
import 'package:em_repairs/provider/model_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:em_repairs/components/other_components/camera_screen.dart';
import 'package:provider/provider.dart';
 // Import the provider

class ImageCaptureGrid extends StatefulWidget {
  final Function(ModelDetailsModel) onModelCaptured;  // Change callback to accept the entire model

  const ImageCaptureGrid({super.key, required this.onModelCaptured});

  @override
  _ImageCaptureGridState createState() => _ImageCaptureGridState();
}

class _ImageCaptureGridState extends State<ImageCaptureGrid> {
  late List<CameraDescription> cameras;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  // Reference to ModelDetailsProvider
  late ModelDetailsModel _modelDetails;

  @override
  void initState() {
    super.initState();
    _modelDetails = ModelDetailsModel();  // Do not generate ID manually, let Appwrite handle it
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
          _navigateToCameraScreen("Device Front", 'frontImagePath');
        }),
        _buildIcon(Icons.photo_camera_back, "Device Back", () {
          _navigateToCameraScreen("Device Back", 'backImagePath');
        }),
        _buildIcon(Icons.camera_alt_rounded, "Left Side Image", () {
          _navigateToCameraScreen("Left Side Image", 'sideImage1Path');
        }),
        _buildIcon(Icons.camera_alt_rounded, "Right Side Image", () {
          _navigateToCameraScreen("Right Side Image", 'sideImage2Path');
        }),
      ],
    );
  }

  // Navigate to the camera screen
  void _navigateToCameraScreen(String title, String imagePathKey) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          title: title,
          controller: _controller,
          initializeControllerFuture: _initializeControllerFuture,
          onCapture: (imagePath) {
            // Update the model with the captured image path
            setState(() {
              _modelDetails = _modelDetails.copyWith(
                frontImagePath: imagePathKey == 'frontImagePath' ? imagePath : _modelDetails.frontImagePath,
                backImagePath: imagePathKey == 'backImagePath' ? imagePath : _modelDetails.backImagePath,
                sideImage1Path: imagePathKey == 'sideImage1Path' ? imagePath : _modelDetails.sideImage1Path,
                sideImage2Path: imagePathKey == 'sideImage2Path' ? imagePath : _modelDetails.sideImage2Path,
              );
            });

            // After capturing all the images, add the model to the provider and pass it to the parent
            _addModelToProvider();
          },
        ),
      ),
    );
  }

  // Add model to the provider and send the saved model to the parent
  void _addModelToProvider() async {
    final modelProvider = Provider.of<ModelDetailsProvider>(context, listen: false);
    await modelProvider.addModel(_modelDetails);  // Add model to Appwrite and provider

    // Send the model to the parent
    widget.onModelCaptured(_modelDetails);
  }

  // Build grid icon and display captured image in the grid
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

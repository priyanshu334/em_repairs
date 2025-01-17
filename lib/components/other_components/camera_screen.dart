import 'package:appwrite/appwrite.dart';
import 'package:camera/camera.dart';
import 'package:em_repairs/services/appwrite_service.dart';
import 'package:flutter/material.dart'; // Import the Appwrite service

class CameraScreen extends StatelessWidget {
  final String title;
  final CameraController controller;
  final Future<void> initializeControllerFuture;
  final Function(String) onCapture;

  const CameraScreen({
    Key? key,
    required this.title,
    required this.controller,
    required this.initializeControllerFuture,
    required this.onCapture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black.withOpacity(0.3),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Camera preview or error/loading screen
          FutureBuilder(
            future: initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(controller);
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.pink),
                );
              }
            },
          ),
          // Gradient overlay for bottom controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Tap the button below to capture a photo",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Capture button
                      GestureDetector(
                        onTap: () async {
                          await _captureImage(context);
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            color: Colors.pink,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Gradient overlay for the top section
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _captureImage(BuildContext context) async {
    final appwriteService = AppwriteService();
    const bucketId = 'YOUR_BUCKET_ID'; // Replace with your bucket ID

    try {
      // Ensure the camera is initialized
      await initializeControllerFuture;

      // Capture the image
      final XFile image = await controller.takePicture();

      // Upload the image to Appwrite bucket
      await appwriteService.uploadFile(bucketId, image.path);

      // Pass the captured image path to the parent widget
      onCapture(image.path);

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing or uploading image: $e')),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:em_repairs/components/other_components/model_details_diloige.dart';

class ModelDetails extends StatefulWidget {
  const ModelDetails({super.key});

  @override
  _ModelDetailsState createState() => _ModelDetailsState();
}

class _ModelDetailsState extends State<ModelDetails> {
  // This is the callback function to handle captured images
  void handleCapturedImages(Map<String, String?> images) {
    setState(() {
      // Handle the captured images, for example, save them to state
      print("Captured images: $images");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            // Pass the handleCapturedImages function to the dialog
            showModelDetailsDialog(context, handleCapturedImages);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade600,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
          ),
          icon: const Icon(
            Icons.info_outline,
            color: Colors.white,
            size: 24,
          ),
          label: const Text(
            "Model Details",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

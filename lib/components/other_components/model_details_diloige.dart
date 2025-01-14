import 'package:em_repairs/models/model_details_model.dart';
import 'package:flutter/material.dart';
import 'image_capture_grid.dart';


void showModelDetailsDialog(BuildContext context, Function(ModelDetailsModel) onModelCaptured) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners for a modern look
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 30),
                  const SizedBox(width: 8),
                  const Text(
                    "Model Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Pass the callback function to handle the captured model ID
              ImageCaptureGrid(
                onModelCaptured: (modelDetails) {
                  // Call the callback passed from the parent
                  onModelCaptured(modelDetails);

                  // Show a Snackbar with the captured model ID or details
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Captured Model ID: ${modelDetails.id}')),
                  );
                  Navigator.pop(context); // Close the dialog after capturing the model
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    label: const Text("Cancel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade600,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle the Done action
                      Navigator.pop(context); // Close the dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Model details saved!')),
                      );
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

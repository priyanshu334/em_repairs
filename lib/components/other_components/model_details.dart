import 'package:em_repairs/components/other_components/camera_screen.dart';
import 'package:em_repairs/components/other_components/model_details_diloige.dart';
import 'package:flutter/material.dart';


class ModelDetails extends StatelessWidget {
  const ModelDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => showModelDetailsDialog(context),
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

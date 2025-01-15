import 'package:em_repairs/models/DeviceKycModels.dart';
import 'package:em_repairs/components/Accessories_form.dart';
import 'package:em_repairs/components/other_components/bar_code_scan_componet.dart';
import 'package:em_repairs/components/other_components/lock_code.dart';
import 'package:em_repairs/components/other_components/model_details.dart'; // For image handling
import 'package:em_repairs/models/accessories_model.dart';
import 'package:em_repairs/provider/device_kycs_provider.dart';
// Import your provider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeviceKycForm extends StatefulWidget {
  final void Function(DeviceKycModels deviceKycModel) onDeviceKycSaved;

  const DeviceKycForm({Key? key, required this.onDeviceKycSaved})
      : super(key: key);

  @override
  _DeviceKycFormState createState() => _DeviceKycFormState();
}

class _DeviceKycFormState extends State<DeviceKycForm> {
  String? frontImagePath;
  String? backImagePath;
  String? sideImage1Path;
  String? sideImage2Path;
  List<int>? lockCode;
  String? patternCode;
  String? barcode;
  Map<String, dynamic>? accessory; // Change to Map<String, dynamic>

  // Handle Model Images
  void _handleModelImagesCaptured(
      String front, String back, String side1, String side2) {
    setState(() {
      frontImagePath = front;
      backImagePath = back;
      sideImage1Path = side1;
      sideImage2Path = side2;
    });
  }

  // Handle Lock Code Generation
  void _handleLockCodeGenerated(List<int> code, String? pattern) {
    setState(() {
      lockCode = code;
      patternCode = pattern;
    });
  }

  // Handle Barcode Scan
  void _handleBarcodeScan(String scannedBarcode) {
    setState(() {
      barcode = scannedBarcode;
    });
  }

  // Handle Accessories Submission
  void _handleAccessoriesSubmitted(AccessoriesModel accessoryModel) {
    setState(() {
      debugPrint(accessoryModel.toString());
      accessory = accessoryModel.toMap();
    });
  }

  // Form Submission
  void _handleFormSubmit() async {
    // Create DeviceKycModels instance
    final deviceKycModel = DeviceKycModels(
      frontImagePath: frontImagePath,
      backImagePath: backImagePath,
      sideImage1Path: sideImage1Path,
      sideImage2Path: sideImage2Path,
      lockCode: lockCode,
      patternCode: patternCode,
      barcode: barcode,
      accessoriesModel: accessory, // Pass accessory as Map<String, dynamic>
    );

    // Save the data using DeviceKycProvider
    final deviceKycProvider =
        Provider.of<DeviceKycProvider>(context, listen: false);
    await deviceKycProvider.saveDeviceKyc(deviceKycModel);

    // Pass data to parent via the callback function
    widget.onDeviceKycSaved(deviceKycModel);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Device KYC saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Device KYC Form",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                ModelDetails(
                    onImagesCaptured:
                        _handleModelImagesCaptured), // Image component
                LockCode(
                    onGeneratedId:
                        _handleLockCodeGenerated), // Lock code component
                BarCodeScannerComponent(
                    onScan: _handleBarcodeScan), // Barcode scanner
                AccessoriesForm(
                    onSubmit: _handleAccessoriesSubmitted), // Accessories form
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _handleFormSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 28),
                    ),
                    child: const Text(
                      "Save KYC",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

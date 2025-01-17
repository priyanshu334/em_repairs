import 'package:em_repairs/models/DeviceKycModels.dart';
import 'package:em_repairs/components/edit_components/accessories_edit.dart';
import 'package:em_repairs/components/other_components/bar_code_scan_componet.dart';
import 'package:em_repairs/components/other_components/lock_code.dart';
import 'package:em_repairs/components/other_components/model_details.dart'; // For image handling
import 'package:em_repairs/models/accessories_model.dart';
import 'package:em_repairs/provider/device_kycs_provider.dart';
// Import your provider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class DeviceKycForm extends StatefulWidget {
  final void Function(DeviceKycModels deviceKycModel) onDeviceKycSaved;
  final DeviceKycModels?
      deviceKycModel; // Add this to receive data for edit mode

  const DeviceKycForm(
      {Key? key, required this.onDeviceKycSaved, this.deviceKycModel})
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

  bool get isEditMode => widget.deviceKycModel != null; // Check if in edit mode

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      // Pre-fill form with existing data if in edit mode
      final deviceKyc = widget.deviceKycModel;
      frontImagePath = deviceKyc?.frontImagePath;
      backImagePath = deviceKyc?.backImagePath;
      sideImage1Path = deviceKyc?.sideImage1Path;
      sideImage2Path = deviceKyc?.sideImage2Path;
      lockCode = deviceKyc?.lockCode;
      patternCode = deviceKyc?.patternCode;
      barcode = deviceKyc?.barcode;
      accessory = deviceKyc?.accessoriesModel;
    }
  }

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
             id: const Uuid().v4(),
      frontImagePath: frontImagePath,
      backImagePath: backImagePath,
      sideImage1Path: sideImage1Path,
      sideImage2Path: sideImage2Path,
      lockCode: lockCode,
      patternCode: patternCode,
      barcode: barcode,
      accessoriesModel: accessory, // Pass accessory as Map<String, dynamic>
    );

    final deviceKycProvider =
        Provider.of<DeviceKycProvider>(context, listen: false);

    if (isEditMode) {
      // If in edit mode, update the device KYC data
      await deviceKycProvider.updateDeviceKyc(deviceKycModel);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device KYC updated successfully')),
      );
    } else {
      // Save the data using DeviceKycProvider (Create new entry)
      await deviceKycProvider.saveDeviceKyc(deviceKycModel);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device KYC saved successfully')),
      );
    }

    // Pass data to parent via the callback function
    widget.onDeviceKycSaved(deviceKycModel);
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
                    onSubmit: _handleAccessoriesSubmitted ,existingAccessory: AccessoriesModel.fromMap(accessory!),), // Accessories form
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
                    child: Text(
                      isEditMode ? "Update KYC" : "Save KYC",
                      style: const TextStyle(
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

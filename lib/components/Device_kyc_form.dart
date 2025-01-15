import 'package:em_repairs/models/DeviceKycModels.dart';
import 'package:em_repairs/provider/device_kycs_provider.dart';
import 'package:flutter/material.dart';
import 'package:em_repairs/models/accessories_model.dart';
import 'package:em_repairs/components/Accessories_form.dart';
import 'package:em_repairs/components/other_components/bar_code_scan_componet.dart';
import 'package:em_repairs/components/other_components/lock_code.dart';
import 'package:em_repairs/components/other_components/model_details.dart';
import 'package:provider/provider.dart';

class DeviceKycForm extends StatefulWidget {
  final Function(DeviceKycModels) onKycSaved; // Callback to parent widget

  const DeviceKycForm({Key? key, required this.onKycSaved}) : super(key: key);

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
  AccessoriesModel? accessory;

  // Handle Model Images
  void _handleModelImagesCaptured(String front, String back, String side1, String side2) {
    setState(() {
      frontImagePath = front;
      backImagePath = back;
      sideImage1Path = side1;
      sideImage2Path = side2;
    });
  }

  // Handle Lock Code
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

  // Handle Accessories
  void _handleAccessoriesSubmitted(AccessoriesModel accessoryModel) {
    setState(() {
      accessory = accessoryModel;
    });
  }

  // Form Submission
  void _handleFormSubmit() {
    final deviceKycModel = DeviceKycModels(
      frontImagePath: frontImagePath,
      backImagePath: backImagePath,
      sideImage1Path: sideImage1Path,
      sideImage2Path: sideImage2Path,
      lockCode: lockCode,
      patternCode: patternCode,
      barcode: barcode,
      accessoriesModel: accessory,
    );

    final provider = Provider.of<DeviceKycProvider>(context, listen: false);

    provider.saveDeviceKyc(deviceKycModel).then((_) {
      // After saving to the provider, call the parent callback with the model
      widget.onKycSaved(deviceKycModel);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device KYC saved successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DeviceKycProvider>(context);

    return Stack(
      children: [
        Padding(
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
                    ModelDetails(onImagesCaptured: _handleModelImagesCaptured),
                    LockCode(onGeneratedId: _handleLockCodeGenerated),
                    BarCodeScannerComponent(onScan: _handleBarcodeScan),
                    AccessoriesForm(onSubmit: _handleAccessoriesSubmitted),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: provider.isLoading ? null : _handleFormSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                        ),
                        child: provider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
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
        ),
        if (provider.isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

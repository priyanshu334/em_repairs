import 'package:em_repairs/models/accessories_model.dart';
import 'package:em_repairs/models/model_details_model.dart';
import 'package:em_repairs/provider/device_kyc_provider.dart';
import 'package:flutter/material.dart';
import 'package:em_repairs/components/Accessories_form.dart';
import 'package:em_repairs/components/other_components/bar_code_scan_componet.dart';
import 'package:em_repairs/components/other_components/lock_code.dart';
import 'package:em_repairs/components/other_components/model_details.dart';
import 'package:em_repairs/models/device_kyc_model.dart';
import 'package:em_repairs/models/bar_code_model.dart';
import 'package:em_repairs/models/lock_code_model.dart';
import 'package:provider/provider.dart';

class DeviceKycForm extends StatefulWidget {
  final Function(DeviceKycModel)? onDeviceKycSaved;

  const DeviceKycForm({Key? key, this.onDeviceKycSaved}) : super(key: key);

  @override
  _DeviceKycFormState createState() => _DeviceKycFormState();
}

class _DeviceKycFormState extends State<DeviceKycForm> {
  ModelDetailsModel? modelDetails;
  LockCodeModel? lockCode;
  BarcodeModel? barcode;
  AccessoriesModel? accessory;

  // Handle captured model details
  void _handleModelCaptured(ModelDetailsModel model) {
    setState(() {
      modelDetails = model;
    });
    debugPrint("Captured Model: ${model.id}");
  }

  // Handle lock code generation
  void _handleLockCodeGenerated(LockCodeModel lockCode) {
    setState(() {
      this.lockCode = lockCode;
    });
    debugPrint("Generated Lock Code: ${lockCode.id}");
  }

  // Handle barcode scan
  void _handleBarcodeScan(BarcodeModel scannedBarcode) {
    setState(() {
      barcode = scannedBarcode;
    });
    debugPrint("Scanned Barcode: ${scannedBarcode.barcode}");
  }

  // Handle accessories submitted
  void _handleAccessoriesSubmitted(AccessoriesModel accessoryModel) {
    setState(() {
      accessory = accessoryModel;
    });
    debugPrint("Selected Accessory: ${accessoryModel.id}");
  }

  // Handle form submission using the provider to save DeviceKycModel
  void _handleFormSubmit() {
    if (modelDetails != null && lockCode != null && barcode != null && accessory != null) {
      final deviceKycModel = DeviceKycModel(
        deviceId: '', // Don't generate UUID, it will be handled by provider
        modelDetailsModel: modelDetails!,
        lockCodeModel: lockCode!,
        barcodeModel: barcode!,
        accessoriesModel: accessory!,
      );

      // Save device KYC using the provider
      final deviceKycProvider = Provider.of<DeviceKycProvider>(context, listen: false);
      deviceKycProvider.saveDeviceKyc(deviceKycModel);

      // Notify the parent that the KYC is saved
      if (widget.onDeviceKycSaved != null) {
        widget.onDeviceKycSaved!(deviceKycModel);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device KYC saved successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Device KYC",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ModelDetails(onModelCaptured: _handleModelCaptured),
              LockCode(onGeneratedId: _handleLockCodeGenerated),
              BarCodeScannerComponent(onScan: _handleBarcodeScan),
              AccessoriesForm(onSubmit: _handleAccessoriesSubmitted),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _handleFormSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                  ),
                  child: const Text(
                    "Save Device KYC",
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
    );
  }
}

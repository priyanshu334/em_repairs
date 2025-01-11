import 'package:flutter/material.dart';
import 'package:em_repairs/components/Accessories_form.dart';
import 'package:em_repairs/components/other_components/bar_code_scan_componet.dart';
import 'package:em_repairs/components/other_components/lock_code.dart';
import 'package:em_repairs/components/other_components/model_details.dart';

class DeviceKycForm extends StatefulWidget {
  final Function(
    bool powerAdapterChecked,
    bool keyboardChecked,
    bool mouseChecked,
    bool warrantyChecked,
    String accessories,
    String details,
    DateTime? warrantyDate,
    List<int>? lockCode, // Added lock code
    List<int>? patternCode, // Added pattern code
  )? onFormSubmit;

  const DeviceKycForm({Key? key, required this.onFormSubmit}) : super(key: key);

  @override
  _DeviceKycFormState createState() => _DeviceKycFormState();
}

class _DeviceKycFormState extends State<DeviceKycForm> {
  // Define variables to store form data
  bool powerAdapterChecked = false;
  bool keyboardChecked = false;
  bool mouseChecked = false;
  bool warrantyChecked = false;
  String accessories = '';
  String details = '';
  DateTime? warrantyDate;
  List<int>? lockCode; // Lock code variable
  List<int>? patternCode; // Pattern code variable

  // Callback to receive data from AccessoriesForm
  void _handleFormData({
    required bool powerAdapterChecked,
    required bool keyboardChecked,
    required bool mouseChecked,
    required bool warrantyChecked,
    required String accessories,
    required String details,
    required DateTime? warrantyDate,
  }) {
    setState(() {
      this.powerAdapterChecked = powerAdapterChecked;
      this.keyboardChecked = keyboardChecked;
      this.mouseChecked = mouseChecked;
      this.warrantyChecked = warrantyChecked;
      this.accessories = accessories;
      this.details = details;
      this.warrantyDate = warrantyDate;
    });

    // Call the parent callback to pass the data
    if (widget.onFormSubmit != null) {
      widget.onFormSubmit!(
        powerAdapterChecked,
        keyboardChecked,
        mouseChecked,
        warrantyChecked,
        accessories,
        details,
        warrantyDate,
        lockCode,
        patternCode,
      );
    }
  }

  // Handlers for Lock Code and Pattern Code
  void _handleLockCodeSet(List<int> code) {
    setState(() {
      lockCode = code;
    });
    // Optionally notify parent widget
    if (widget.onFormSubmit != null) {
      widget.onFormSubmit!(
        powerAdapterChecked,
        keyboardChecked,
        mouseChecked,
        warrantyChecked,
        accessories,
        details,
        warrantyDate,
        lockCode,
        patternCode,
      );
    }
  }

  void _handlePatternCodeSet(List<int> code) {
    setState(() {
      patternCode = code;
    });
    // Optionally notify parent widget
    if (widget.onFormSubmit != null) {
      widget.onFormSubmit!(
        powerAdapterChecked,
        keyboardChecked,
        mouseChecked,
        warrantyChecked,
        accessories,
        details,
        warrantyDate,
        lockCode,
        patternCode,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Section
                Text(
                  "Device KYC",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 16),

                // Model Details Component
                _buildSection(
                  title: "Model Details",
                  child: ModelDetails(),
                ),

                SizedBox(height: 16),

                // Lock Code Component
                _buildSection(
                  title: "Lock Code",
                  child: LockCodeComponent(
                    onLockCodeSet: _handleLockCodeSet,
                    onPatternCodeSet: _handlePatternCodeSet,
                  ),
                ),

                SizedBox(height: 16),

                // Bar Code Component
                _buildSection(
                  title: "Bar Code",
                  child: BarCodeScannerComponent(),
                ),

                // Accessories Form
                _buildSection(
                  title: "Accessories",
                  child: AccessoriesForm(
                    onDataChanged: _handleFormData, // Pass the callback to AccessoriesForm
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build titled sections with consistent styling
  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        child,
      ],
    );
  }
}

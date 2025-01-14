import 'package:em_repairs/components/other_components/bar_code_scan_page.dart';
import 'package:em_repairs/models/bar_code_model.dart';
import 'package:em_repairs/provider/bar_code_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarCodeScannerComponent extends StatelessWidget {
  final Function(BarcodeModel) onScan; // Callback to send the full BarcodeModel to the parent

  const BarCodeScannerComponent({super.key, required this.onScan});

  @override
  Widget build(BuildContext context) {
    final barcodeProvider = Provider.of<BarcodeProvider>(context, listen: false);

    return SizedBox(
      width: double.infinity, // Full-width button
      child: ElevatedButton.icon(
        onPressed: () {
          // Open the Barcode Scanner Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BarcodeScannerPage(
                onScan: (scannedBarcode) async {
                  if (scannedBarcode.isNotEmpty) {
                    // Create the barcode model without generating an ID manually
                    BarcodeModel barcodeModel = BarcodeModel(
                      id: '', // Appwrite will generate the ID
                      barcode: scannedBarcode,
                    );

                    // Save the barcode using the provider (Appwrite will generate the unique ID)
                    await barcodeProvider.addBarcode(barcodeModel);

                    // Get the saved barcode model (last item in the list)
                    final BarcodeModel savedBarcode = barcodeProvider.barcodes.last;

                    // Pass the full saved model to the parent
                    onScan(savedBarcode);

                    // Close the barcode scanner page
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No barcode detected!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
          );
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
          Icons.qr_code_scanner,
          color: Colors.white,
          size: 24,
        ),
        label: const Text(
          'Open Barcode Scanner',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

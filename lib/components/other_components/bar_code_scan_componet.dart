import 'package:em_repairs/components/other_components/bar_code_scan_page.dart';
import 'package:flutter/material.dart';

class BarCodeScannerComponent extends StatelessWidget {
  final Function(String scannedBarcode) onScan; // Callback to send the scanned barcode string to the parent

  const BarCodeScannerComponent({super.key, required this.onScan});

  @override
  Widget build(BuildContext context) {
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
                    // Pass the scanned barcode string to the parent
                    onScan(scannedBarcode);

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

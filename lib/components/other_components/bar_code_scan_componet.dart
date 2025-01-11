import 'package:flutter/material.dart';
import 'bar_code_scan_page.dart'; // Import the BarcodeScannerPage

class BarCodeScannerComponent extends StatelessWidget {
  final Function(String scannedBarcode)? onScan; // Callback for scanned barcode

  const BarCodeScannerComponent({super.key, this.onScan});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Open the Barcode Scanner Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BarcodeScannerPage(
              onScan: (scannedBarcode) {
                // Trigger the callback with the scanned barcode
                if (onScan != null) {
                  onScan!(scannedBarcode);
                }

                // Optionally, show a message in the current context
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Scanned Barcode: $scannedBarcode'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Open Barcode Scanner',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

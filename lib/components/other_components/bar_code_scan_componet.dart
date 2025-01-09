import 'package:em_repairs/components/other_components/bar_code_scan_page.dart';
import 'package:flutter/material.dart';
// import BarcodeScannerPage

class BarCodeScannerComponent extends StatelessWidget {
  const BarCodeScannerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BarCode Scanner Component'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Open the Barcode Scanner Page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BarcodeScannerPage(
                  onScan: (scannedBarcode) {
                    // Handle the scanned barcode
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
        ),
      ),
    );
  }
}

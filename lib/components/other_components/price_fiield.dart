import 'package:flutter/material.dart';

class PriceField extends StatefulWidget {
  final TextEditingController priceController;

  const PriceField({super.key, required this.priceController});

  @override
  State<PriceField> createState() => _PriceFieldState();
}

class _PriceFieldState extends State<PriceField> {
  String? _errorMessage; // Error message for validation

  void _validateInput(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _errorMessage = 'Price is required';
      } else {
        final numericValue = double.tryParse(value);
        if (numericValue == null || numericValue <= 0) {
          _errorMessage = 'Enter a valid positive price';
        } else {
          _errorMessage = null; // Input is valid
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Price:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: widget.priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: "Please enter the price",
              errorText: _errorMessage, // Display error message
            ),
            onChanged: _validateInput, // Validate input in real-time
          ),
        ],
      ),
    );
  }
}
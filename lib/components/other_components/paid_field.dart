import 'package:flutter/material.dart';

class PaidField extends StatefulWidget {
  final TextEditingController paidController;

  const PaidField({super.key, required this.paidController});

  @override
  State<PaidField> createState() => _PaidFieldState();
}

class _PaidFieldState extends State<PaidField> {
  String? _errorMessage; // Error message for validation

  void _validateInput(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _errorMessage = 'Paid amount is required';
      } else {
        final numericValue = double.tryParse(value);
        if (numericValue == null || numericValue <= 0) {
          _errorMessage = 'Enter a valid positive number';
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
            "Paid:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: widget.paidController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: "Enter paid amount",
              errorText: _errorMessage, // Display error message
            ),
            onChanged: _validateInput, // Validate input in real-time
          ),
        ],
      ),
    );
  }
}
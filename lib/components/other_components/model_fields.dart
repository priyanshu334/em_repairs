import 'package:flutter/material.dart';

class ModelField extends StatefulWidget {
  final TextEditingController textController;

  const ModelField({super.key, required this.textController});

  @override
  State<ModelField> createState() => _ModelFieldState();
}

class _ModelFieldState extends State<ModelField> {
  String? _errorMessage; // Holds the error message

  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorMessage = 'Please enter a model name';
      } else if (value.length < 3) {
        _errorMessage = 'Model name must be at least 3 characters long';
      } else {
        _errorMessage = null; // Input is valid
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Model",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: widget.textController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Model..',
                errorText: _errorMessage, // Display error message
              ),
              onChanged: _validateInput, // Validate input on change
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
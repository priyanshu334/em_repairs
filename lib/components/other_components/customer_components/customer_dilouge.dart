import 'package:flutter/material.dart';

class CustomerDialog extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onAdd;

  const CustomerDialog({
    Key? key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.formKey,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enter Customer Details"),
      content: Form(
        key: formKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Customer Name"),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Name is required' : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Customer Phone No"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Customer Address"),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Address is required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
        TextButton(
          onPressed: onAdd,
          child: const Text("Add"),
        ),
      ],
    );
  }
}

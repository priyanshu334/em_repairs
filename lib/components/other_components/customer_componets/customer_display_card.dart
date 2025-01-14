import 'package:flutter/material.dart';
import 'package:em_repairs/models/customer_model.dart';

class CustomerDisplayCard extends StatelessWidget {
  final CustomerModel? selectedCustomer;
  final Function onClearSelection;

  const CustomerDisplayCard({
    super.key,
    this.selectedCustomer,
    required this.onClearSelection,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedCustomer == null) return SizedBox.shrink();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selected Customer: ${selectedCustomer!.name}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Phone: ${selectedCustomer!.phone}"),
                  Text("Address: ${selectedCustomer!.address}"),
                ],
              ),
            ),
            IconButton(
              onPressed: () => onClearSelection(),
              icon: const Icon(Icons.cancel, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

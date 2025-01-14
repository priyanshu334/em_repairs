import 'package:flutter/material.dart';

class CustomerCard extends StatelessWidget {
  final Map<String, String> customer;
  final VoidCallback onRemove;

  const CustomerCard({
    Key? key,
    required this.customer,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    "Selected Customer: ${customer['name']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Phone: ${customer['phone']}"),
                  Text("Address: ${customer['address']}"),
                ],
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.cancel, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

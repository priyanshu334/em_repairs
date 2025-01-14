import 'package:flutter/material.dart';
import 'package:em_repairs/models/customer_model.dart';  // Import the CustomerModel

class SelectedCustomerCard extends StatelessWidget {
  final CustomerModel customer;  // Changed from Map<String, String> to CustomerModel
  final VoidCallback onRemove;

  const SelectedCustomerCard({
    super.key,
    required this.customer,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Customer Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    children: [
                      Icon(
                        Icons.person_rounded,
                        color: Colors.teal.shade800,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Selected Customer",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.teal.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Name Row
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle_rounded,
                        color: Colors.teal.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Name: ${customer.name ?? 'N/A'}",  // Accessing the 'name' directly from the model
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.teal.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Phone Row
                  Row(
                    children: [
                      Icon(
                        Icons.phone_rounded,
                        color: Colors.teal.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Phone: ${customer.phone ?? 'N/A'}",  // Accessing the 'phone' directly
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.teal.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Address Row
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Colors.teal.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Address: ${customer.address ?? 'N/A'}",  // Accessing the 'address' directly
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.teal.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Remove Button with Icon
            IconButton(
              onPressed: onRemove,
              icon: Icon(
                Icons.cancel_rounded,
                color: Colors.red.shade600,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

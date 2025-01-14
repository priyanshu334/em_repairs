import 'package:em_repairs/provider/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:em_repairs/models/customer_model.dart';

class CustomerListDialog extends StatelessWidget {
  final ValueChanged<String> onSelect;  // Change type to String (ID)

  const CustomerListDialog({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch customers from the provider
    return Consumer<CustomerProvider>(
      builder: (context, customerProvider, _) {
        // If the list of customers is empty, fetch them
        if (customerProvider.customers.isEmpty) {
          customerProvider.fetchCustomers();
        }

        return AlertDialog(
          title: const Text("Select a Customer"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: customerProvider.customers.length,
              itemBuilder: (context, index) {
                final customer = customerProvider.customers[index];
                return ListTile(
                  title: Text(customer.name ?? 'No Name'),
                  subtitle: Text("Phone: ${customer.phone}\nAddress: ${customer.address}"),
                  isThreeLine: true,
                  onTap: () {
                    onSelect(customer.id);  // Send the customer ID to the parent
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

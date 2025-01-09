import 'package:flutter/material.dart';

class CustomerListDialog extends StatelessWidget {
  final List<Map<String, String>> customers;
  final ValueChanged<Map<String, String>> onSelect;

  const CustomerListDialog({
    super.key,
    required this.customers,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select a Customer"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final customer = customers[index];
            return ListTile(
              title: Text(customer['name'] ?? 'No Name'),
              subtitle: Text("Phone: ${customer['phone']}\nAddress: ${customer['address']}"),
              isThreeLine: true,
              onTap: () {
                onSelect(customer);
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
  }
}

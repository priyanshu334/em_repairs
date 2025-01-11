import 'package:em_repairs/provider/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CustomerListDialog extends StatelessWidget {
  final ValueChanged<Map<String, String>> onSelect;

  const CustomerListDialog({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select a Customer"),
      content: Consumer<CustomerProvider>(
        builder: (context, customerProvider, _) {
          final customers = customerProvider.customers;

          if (customers.isEmpty) {
            return const Center(
              child: Text("No customers available. Please add some."),
            );
          }

          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ListTile(
                  title: Text(customer.name),
                  subtitle: Text("Phone: ${customer.phone}\nAddress: ${customer.address}"),
                  isThreeLine: true,
                  onTap: () {
                    onSelect({
                      'name': customer.name,
                      'phone': customer.phone,
                      'address': customer.address,
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          );
        },
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

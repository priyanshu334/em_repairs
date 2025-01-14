import 'package:flutter/material.dart';
import 'package:em_repairs/models/customer_model.dart';

class CustomerList extends StatelessWidget {
  final List<CustomerModel> customers; // Use CustomerModel instead of Map<String, String>
  final Function(CustomerModel) onCustomerSelected; // Expect CustomerModel instead of Map<String, String>

  const CustomerList({
    super.key,
    required this.customers,
    required this.onCustomerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return ListTile(
          title: Text(customer.name), // Use customer.name directly
          subtitle: Text("Phone: ${customer.phone}\nAddress: ${customer.address}"),
          isThreeLine: true,
          onTap: () => onCustomerSelected(customer), // Pass CustomerModel instead of Map
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:em_repairs/models/customer_model.dart';

class CustomerDisplayCard extends StatelessWidget {
  final CustomerModel? selectedCustomer;
  final VoidCallback onClearSelection;
  final VoidCallback onEdit;

  const CustomerDisplayCard({
    required this.selectedCustomer,
    required this.onClearSelection,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(selectedCustomer?.name ?? "No customer selected"),
        subtitle: Text(selectedCustomer?.phone ?? ""),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: onClearSelection,
            ),
          ],
        ),
      ),
    );
  }
}

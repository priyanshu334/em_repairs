// lib/components/selected_customers_page.dart
import 'package:flutter/material.dart';

class SelectedCustomersPage extends StatelessWidget {
  final List<String> selectedCustomers;
  final Function clearSelectedCustomers;

  const SelectedCustomersPage({
    Key? key,
    required this.selectedCustomers,
    required this.clearSelectedCustomers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Customers'),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              clearSelectedCustomers();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: selectedCustomers.isEmpty
          ? const Center(
              child: Text(
                'No customers selected',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: selectedCustomers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    selectedCustomers[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
    );
  }
}
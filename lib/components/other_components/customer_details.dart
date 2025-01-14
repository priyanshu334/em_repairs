import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:em_repairs/provider/customer_provider.dart';
import 'package:em_repairs/models/customer_model.dart';
import 'package:em_repairs/components/other_components/customer_components/cusomer_action_row.dart';
import 'package:em_repairs/components/other_components/customer_components/customer_card.dart';
import 'package:em_repairs/components/other_components/customer_components/customer_dilouge.dart';

class CustomerDetails extends StatefulWidget {
  final TextEditingController searchController;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final Function(String) onCustomerSelected;

  const CustomerDetails({
    super.key,
    required this.searchController,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.onCustomerSelected,
  });

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final _formKey = GlobalKey<FormState>();

  // Add a customer
  void _addCustomer(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final customerProvider =
          Provider.of<CustomerProvider>(context, listen: false);

      // Generate a new UUID for the customer ID
      var uuid = Uuid();
      final newCustomer = CustomerModel(
        id: uuid.v4(),
        name: widget.nameController.text,
        phone: widget.phoneController.text,
        address: widget.addressController.text,
      );

      try {
        await customerProvider.addCustomer(newCustomer);

        // Clear the form fields
        widget.nameController.clear();
        widget.phoneController.clear();
        widget.addressController.clear();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer added successfully!')),
        );

        // Close the dialog
        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add customer: $e')),
        );
      }
    }
  }

  // Select a customer
  void _selectCustomer(BuildContext context) {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    showDialog<CustomerModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select a Customer"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Consumer<CustomerProvider>(
              builder: (context, provider, child) {
                if (provider.customers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: provider.customers.length,
                  itemBuilder: (context, index) {
                    final customer = provider.customers[index];
                    return ListTile(
                      title: Text(customer.name),
                      subtitle: Text(
                        "Phone: ${customer.phone}\nAddress: ${customer.address}",
                      ),
                      isThreeLine: true,
                      onTap: () {
                        customerProvider.selectCustomer(customer);
                        widget.onCustomerSelected(customer.id);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, customerProvider, child) {
        final selectedCustomer = customerProvider.selectedCustomer;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Customer Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (selectedCustomer != null)
                    CustomerCard(
                      customer: {
                        'name': selectedCustomer.name,
                        'phone': selectedCustomer.phone,
                        'address': selectedCustomer.address,
                      },
                      onRemove: () =>
                          customerProvider.removeSelectedCustomer(),
                    )
                  else
                    const Text(
                      "No customer selected.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 16),
                  CustomerActionRow(
                    searchController: widget.searchController,
                    onSelect: () => _selectCustomer(context),
                    onAdd: () => showDialog(
                      context: context,
                      builder: (_) => CustomerDialog(
                        nameController: widget.nameController,
                        phoneController: widget.phoneController,
                        addressController: widget.addressController,
                        formKey: _formKey,
                        onAdd: () => _addCustomer(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:em_repairs/models/customer_model.dart';
import 'package:em_repairs/provider/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:em_repairs/components/other_components/customer_components/add_customer_form.dart';
import 'package:em_repairs/components/other_components/customer_components/customer_list_dilouge.dart';
import 'package:em_repairs/components/other_components/customer_components/select_customer_card.dart';

class CustomerDetails extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const CustomerDetails({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
  });

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String>? _selectedCustomer;

  void _selectCustomer(Map<String, String> customer) {
    setState(() {
      _selectedCustomer = customer;
    });
    Navigator.pop(context);
  }

  void _removeSelectedCustomer() {
    setState(() {
      _selectedCustomer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedCustomer != null)
                SelectedCustomerCard(
                  customer: _selectedCustomer!,
                  onRemove: _removeSelectedCustomer,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => _showCustomerListDialog(context),
                    child: const Text('Select Customer'),
                  ),
                  ElevatedButton(
                    onPressed: () => _showAddCustomerDialog(context),
                    child: const Text('Add Customer'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCustomerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddCustomerForm(
          formKey: _formKey,
          nameController: widget.nameController,
          phoneController: widget.phoneController,
          addressController: widget.addressController,
          onAdd: () {
            if (_formKey.currentState?.validate() ?? false) {
              final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
              customerProvider.addCustomer(
                CustomerModel(
                  name: widget.nameController.text,
                  phone: widget.phoneController.text,
                  address: widget.addressController.text,
                ),
              );
              widget.nameController.clear();
              widget.phoneController.clear();
              widget.addressController.clear();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Customer Added')),
              );
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  void _showCustomerListDialog(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);

    // Fetch customers before showing the dialog
    customerProvider.fetchCustomers().then((_) {
      showDialog(
        context: context,
        builder: (context) {
          return Consumer<CustomerProvider>(
            builder: (context, provider, _) {
              final customers = provider.customers
                  .map((customer) => {
                        'name': customer.name,
                        'phone': customer.phone,
                        'address': customer.address,
                      })
                  .toList();

              return CustomerListDialog(
                customers: customers,
                onSelect: _selectCustomer,
              );
            },
          );
        },
      );
    });
  }
}

class SelectedCustomerCard extends StatelessWidget {
  final Map<String, String> customer;
  final VoidCallback onRemove;

  const SelectedCustomerCard({Key? key, required this.customer, required this.onRemove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${customer['name']}',
              style:TextStyle(color: Colors.red,fontWeight: FontWeight.bold)
            ),
            Text(
              'Phone: ${customer['phone']}',
              style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
            ),
            Text(
              'Address: ${customer['address']}',
              style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onRemove,
              child: const Text('Remove Customer'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddCustomerForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final VoidCallback onAdd;

  const AddCustomerForm({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Customer'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the phone number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the address';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onAdd,
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class CustomerListDialog extends StatelessWidget {
  final List<Map<String, String>> customers;
  final void Function(Map<String, String>) onSelect;

  const CustomerListDialog({
    Key? key,
    required this.customers,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Customer'),
      content: ListView.builder(
        shrinkWrap: true,
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return ListTile(
            title: Text(customer['name']!),
            subtitle: Text(customer['phone']!),
            onTap: () => onSelect(customer),
          );
        },
      ),
    );
  }
}

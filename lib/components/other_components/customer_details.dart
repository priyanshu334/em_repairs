import 'package:em_repairs/provider/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:em_repairs/services/apwrite_service.dart';

import 'package:em_repairs/components/other_components/customer_componets/customer_display_card.dart';
import 'package:em_repairs/components/other_components/customer_componets/customer_form.dart';
import 'package:em_repairs/components/other_components/customer_componets/customer_list.dart';
import 'package:em_repairs/models/customer_model.dart';

class CustomerDetails extends StatefulWidget {
  final Function(CustomerModel?) onCustomerSelected;

  const CustomerDetails({
    super.key,
    required this.onCustomerSelected,
  });

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  List<CustomerModel> _customers = [];
  CustomerModel? _selectedCustomer;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  // Load customers from the provider
  Future<void> _loadCustomers() async {
    final provider = Provider.of<CustomerProvider>(context, listen: false);
    await provider.fetchCustomers();
    setState(() {
      _customers = provider.customers;
    });
  }

  // Show dialog to add a customer
  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Customer Details"),
          content: CustomerForm(
            nameController: nameController,
            phoneController: phoneController,
            addressController: addressController,
            formKey: _formKey,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final provider = Provider.of<CustomerProvider>(context, listen: false);
                  final customer = CustomerModel(
                    name: nameController.text,
                    phone: phoneController.text,
                    address: addressController.text,
                  );

                  provider.addCustomer(customer);
                  nameController.clear();
                  phoneController.clear();
                  addressController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Customer Added')),
                  );
                  Navigator.pop(context);
                  _loadCustomers(); // Refresh the customer list after adding
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Show dialog to select a customer
  void _showSelectCustomerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select a Customer"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            child: CustomerList(
              customers: _customers,
              onCustomerSelected: (customer) {
                setState(() {
                  _selectedCustomer = customer;
                });
                Navigator.pop(context);
                widget.onCustomerSelected(_selectedCustomer); // Send selected customer to parent
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
              // Title
              const Text(
                "Customer Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),

              // Display Customer Selection Card
              CustomerDisplayCard(
                selectedCustomer: _selectedCustomer,
                onClearSelection: () {
                  setState(() {
                    _selectedCustomer = null;
                  });
                  widget.onCustomerSelected(null); // Notify parent that selection was cleared
                },
              ),
              const SizedBox(height: 16),

              // Customer Selection & Add Buttons
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Search and select from the list",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pink.shade300,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        // Update search results dynamically
                        final provider = Provider.of<CustomerProvider>(context, listen: false);
                        setState(() {
                          _customers = provider.customers
                              .where((customer) => customer.name.toLowerCase().contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _showSelectCustomerDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Select",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _showAddCustomerDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:em_repairs/components/other_components/customer_components/add_customer_form.dart';
import 'package:em_repairs/components/other_components/customer_components/customer_list_dilouge.dart';
import 'package:em_repairs/components/other_components/customer_components/search_and_action.dart';
import 'package:em_repairs/components/other_components/customer_components/select_customer_card.dart';
import 'package:flutter/material.dart';


class CustomerDetails extends StatefulWidget {
  final TextEditingController searchController;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const CustomerDetails({
    super.key,
    required this.searchController,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
  });

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, String>> _customers = [];
  Map<String, String>? _selectedCustomer;

  void _addCustomer() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _customers.add({
          'name': widget.nameController.text,
          'phone': widget.phoneController.text,
          'address': widget.addressController.text,
        });
      });

      widget.nameController.clear();
      widget.phoneController.clear();
      widget.addressController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer Added')),
      );
    }
  }

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
              SearchAndActions(
                searchController: widget.searchController,
                onSelect: () => _showCustomerListDialog(context),
                onAdd: () => _showAddCustomerDialog(context),
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
            _addCustomer();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showCustomerListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomerListDialog(
          customers: _customers,
          onSelect: _selectCustomer,
        );
      },
    );
  }
}

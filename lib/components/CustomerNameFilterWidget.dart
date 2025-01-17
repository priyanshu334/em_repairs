import 'package:flutter/material.dart';
import 'package:em_repairs/provider/customer_provider.dart';
import 'package:provider/provider.dart';

class CustomerNameFilterWidget extends StatelessWidget {
  final Function(String)? onCustomerNameChanged;

  const CustomerNameFilterWidget({Key? key, this.onCustomerNameChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    return TextField(
      decoration: InputDecoration(
        hintText: 'Enter Customer Name',
        suffixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      onChanged: (value) {
        customerProvider.searchCustomers(value!);
        if (onCustomerNameChanged != null) {
          onCustomerNameChanged!(value);
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:em_repairs/provider/customer_provider.dart';
import 'package:provider/provider.dart';

class SearchResultsWidget extends StatelessWidget {
  final String searchQuery;

  const SearchResultsWidget({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Search Results:", style: TextStyle(fontWeight: FontWeight.bold)),
          ...customerProvider.customers
              .where((customer) => customer.name.toLowerCase().contains(searchQuery.toLowerCase()))
              .map((customer) => ListTile(
                    title: Text(customer.name),
                    subtitle: Text(customer.phone),
                    onTap: () {
                      // Handle selection if needed
                    },
                  ))
              .toList(),
        ],
      ),
    );
  }
}

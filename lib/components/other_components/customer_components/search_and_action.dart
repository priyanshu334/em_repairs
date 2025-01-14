import 'package:em_repairs/provider/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SearchAndActions extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSelect;
  final VoidCallback onAdd;

  const SearchAndActions({
    super.key,
    required this.searchController,
    required this.onSelect,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    // Listen to CustomerProvider to get the list of customers
    return Consumer<CustomerProvider>(
      builder: (context, customerProvider, _) {
        // Get the filtered list based on the search query
        List filteredCustomers = customerProvider.searchCustomers(searchController.text);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Customer Details:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 5),
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
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onChanged: (query) {
                      // Trigger the search whenever the text changes
                      customerProvider.notifyListeners();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: onSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade900,
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
                    onPressed: onAdd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade600,
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
            const SizedBox(height: 15),
            if (filteredCustomers.isEmpty)
              const Text("No customers found."),
            // Display the filtered customers in a ListView
            Expanded(
              child: ListView.builder(
                itemCount: filteredCustomers.length,
                itemBuilder: (context, index) {
                  final customer = filteredCustomers[index];
                  return ListTile(
                    title: Text(customer.name ?? 'No Name'),
                    subtitle: Text("Phone: ${customer.phone}\nAddress: ${customer.address}"),
                    isThreeLine: true,
                    onTap: () {
                      // Handle selection of a customer (pass ID or customer data)
                      onSelect();
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

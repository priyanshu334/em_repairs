import 'package:flutter/material.dart';

class CanceledPage extends StatefulWidget {
  const CanceledPage({super.key});

  @override
  State<CanceledPage> createState() => _CanceledPageState();
}

class _CanceledPageState extends State<CanceledPage> {
  List<Map<String, dynamic>> canceledOrders = [
    // Sample data for demonstration
    {'_id': 1, 'receiver': 'John Doe', 'model': 'iPhone 12', 'problem': 'Screen cracked', 'price': '200 USD'},
    {'_id': 2, 'receiver': 'Jane Smith', 'model': 'Samsung Galaxy S21', 'problem': 'Battery issue', 'price': '150 USD'},
  ];

  @override
  void initState() {
    super.initState();
  }

  void deleteOrder(int id) {
    setState(() {
      canceledOrders.removeWhere((order) => order['_id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          "Customers with Canceled Status",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: canceledOrders.isEmpty
          ? const Center(
              child: Text(
                'No customers with canceled status',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: canceledOrders.length,
              itemBuilder: (context, index) {
                final order = canceledOrders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.pink),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer: ${order['receiver'] ?? 'Unknown'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Model: ${order['model'] ?? 'Not available'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Problem: ${order['problem'] ?? 'Not available'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Price: ${order['price'] ?? 'Not available'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              deleteOrder(order['_id']); // Pass the order ID for deletion
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              'Remove Record',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

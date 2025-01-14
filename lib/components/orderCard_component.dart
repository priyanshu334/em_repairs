import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ID: ${order["id"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Customer: ${order["customerName"]}"),
            const SizedBox(height: 8),
            Text("Model: ${order["model"]}"),
            const SizedBox(height: 8),
            Text(
              order["status"],
              style: TextStyle(
                color: order["status"] == "Pending"
                    ? Colors.orange
                    : order["status"] == "Repaired"
                        ? Colors.green
                        : order["status"] == "Delivered"
                            ? Colors.blue
                            : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

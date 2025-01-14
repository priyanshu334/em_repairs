import 'package:em_repairs/components/orderCard_component.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> orders;

  const OrderList({
    Key? key,
    required this.title,
    required this.orders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: orders.map((order) => OrderCard(order: order)).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

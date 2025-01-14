import 'package:em_repairs/provider/order_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:em_repairs/models/order_details_models.dart';
import 'package:provider/provider.dart';


class OrderDetails extends StatefulWidget {
  final String? orderId; // ID of the order to update (if any)

  const OrderDetails({
    Key? key,
    this.orderId,
  }) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final TextEditingController _deviceModelController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  final Uuid uuid = Uuid();
  final List<String> _problems = [];

  String _selectedOrderStatus = 'Pending';
  final List<String> _orderStatusOptions = [
    'Pending',
    'Repaired',
    'Delivered',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.orderId != null) {
      _loadOrderDetails();
    }
  }

  Future<void> _loadOrderDetails() async {
    final provider = Provider.of<OrderDetailsProvider>(context, listen: false);
    try {
      final order = await provider.getOrderDetailById(widget.orderId!);
      setState(() {
        _deviceModelController.text = order.deviceModel;
        _problems.addAll(order.problems);
        _selectedOrderStatus = _orderStatusOptions[order.orderStatus.index];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading order details: $e")),
      );
    }
  }

  void _addProblem() {
    if (_problemController.text.isNotEmpty) {
      setState(() {
        _problems.add(_problemController.text);
        _problemController.clear();
      });
    }
  }

  void _removeProblem(int index) {
    setState(() {
      _problems.removeAt(index);
    });
  }

  Future<void> _onSave() async {
    final provider = Provider.of<OrderDetailsProvider>(context, listen: false);

    try {
      if (widget.orderId == null) {
        // Create a new order
        final order = OrderDetailsModel(
          id: uuid.v4(),
          deviceModel: _deviceModelController.text,
          orderStatus: OrderStatus.values[_orderStatusOptions.indexOf(_selectedOrderStatus)],
          problems: _problems,
        );
        await provider.addOrder(order);
      } else {
        // Update an existing order
        final order = OrderDetailsModel(
          id: widget.orderId!,
          deviceModel: _deviceModelController.text,
          orderStatus: OrderStatus.values[_orderStatusOptions.indexOf(_selectedOrderStatus)],
          problems: _problems,
        );
        await provider.updateOrder(order);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.orderId == null ? "Order added successfully!" : "Order updated successfully!"),
        ),
      );

      Navigator.of(context).pop(); // Close the form
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving order: $e")),
      );
    }
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
              const Text(
                "Order Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _deviceModelController,
                decoration: InputDecoration(
                  labelText: "Enter Device Model",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.devices),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Order Status",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedOrderStatus,
                items: _orderStatusOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedOrderStatus = newValue!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Problems List",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _problemController,
                      decoration: InputDecoration(
                        labelText: 'Describe Problems',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.error_outline),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addProblem,
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _problems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_problems[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _removeProblem(index),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    widget.orderId == null ? "Save Order" : "Update Order",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

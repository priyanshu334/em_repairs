import 'package:em_repairs/models/order_details_models.dart';
import 'package:em_repairs/provider/order_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class OrderDetailsForm extends StatefulWidget {
  final Function(OrderDetailsModel order)
      onOrderAdded; // Callback for the entire order object
  final OrderDetailsModel? existingOrder; // Existing order to edit (nullable)

  const OrderDetailsForm({
    Key? key,
    required this.onOrderAdded,
    this.existingOrder,
  }) : super(key: key);

  @override
  _OrderDetailsFormState createState() => _OrderDetailsFormState();
}

class _OrderDetailsFormState extends State<OrderDetailsForm> {
  final TextEditingController _deviceModelController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
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

    // Initialize fields if editing an existing order
    if (widget.existingOrder != null) {
      _deviceModelController.text = widget.existingOrder!.deviceModel;
      _selectedOrderStatus = widget.existingOrder!.orderStatus.toString();
      _problems.addAll(widget.existingOrder!.problems);
    }
  }

  @override
  void didUpdateWidget(covariant OrderDetailsForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the existing order changes, update the form with the new order details
    if (widget.existingOrder != oldWidget.existingOrder) {
      _deviceModelController.text = widget.existingOrder?.deviceModel ?? '';
      _selectedOrderStatus = widget.existingOrder != null
          ? widget.existingOrder!.orderStatus.toString()
          : 'Pending';

      _problems.addAll(widget.existingOrder?.problems ?? []);
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

  void _onSave() async {
    if (_deviceModelController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Device model cannot be empty.")),
      );
      return;
    }

    if (_problems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one problem.")),
      );
      return;
    }

    // Create or update the order object
    final order = OrderDetailsModel(
      id: widget.existingOrder?.id ??
          const Uuid().v4(), // Use existing ID if updating
      deviceModel: _deviceModelController.text,
      orderStatus:
          OrderStatus.values[_orderStatusOptions.indexOf(_selectedOrderStatus)],
      problems: _problems,
    );

    try {
      final provider =
          Provider.of<OrderDetailsProvider>(context, listen: false);

      if (widget.existingOrder == null) {
        await provider.addOrder(order);
      } else {
        await provider.updateOrder(order);
      }

      widget.onOrderAdded(order);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.existingOrder == null
              ? "Order added successfully!"
              : "Order updated successfully!"),
        ),
      );
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
                value: _orderStatusOptions.contains(_selectedOrderStatus)
                    ? _selectedOrderStatus
                    : null,
                items: _orderStatusOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedOrderStatus =
                        newValue ?? 'Pending'; // Default to 'Pending' if null
                  });
                },
                decoration: InputDecoration(
                  labelText: "Select Order Status",
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
                    widget.existingOrder == null
                        ? "Save Order"
                        : "Update Order",
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

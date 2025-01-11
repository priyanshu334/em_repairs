import 'package:flutter/material.dart';

class OrderDetailsForm extends StatefulWidget {
  final TextEditingController deviceModelController;
  final TextEditingController problemController;
  final Function(String, List<String>, String?) onOrderDetailsChanged;
  final List<String> orderStatusOptions;

  const OrderDetailsForm({
    Key? key,
    required this.deviceModelController,
    required this.problemController,
    required this.onOrderDetailsChanged,
    required this.orderStatusOptions,
  }) : super(key: key);

  @override
  _OrderDetailsFormState createState() => _OrderDetailsFormState();
}

class _OrderDetailsFormState extends State<OrderDetailsForm> {
  final List<String> _problems = [];
  String? _selectedOrderStatus;

  void _addProblem() {
    if (widget.problemController.text.isNotEmpty) {
      setState(() {
        _problems.add(widget.problemController.text.trim());
        widget.problemController.clear();
      });
      widget.onOrderDetailsChanged(
          widget.deviceModelController.text.trim(), _problems, _selectedOrderStatus);
    }
  }

  void _removeProblem(int index) {
    setState(() {
      _problems.removeAt(index);
    });
    widget.onOrderDetailsChanged(
        widget.deviceModelController.text.trim(), _problems, _selectedOrderStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedOrderStatus,
              hint: const Text('Select Order Status'),
              items: widget.orderStatusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOrderStatus = value;
                });
                widget.onOrderDetailsChanged(
                    widget.deviceModelController.text.trim(),
                    _problems,
                    _selectedOrderStatus);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Device Model:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: widget.deviceModelController,
              decoration: InputDecoration(
                labelText: 'Enter Model',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.devices),
              ),
              onChanged: (_) {
                widget.onOrderDetailsChanged(
                    widget.deviceModelController.text.trim(),
                    _problems,
                    _selectedOrderStatus);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Problems List:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.problemController,
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
                  child: const Text('Add'),
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
          ],
        ),
      ),
    );
  }
}

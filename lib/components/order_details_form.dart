import 'package:flutter/material.dart';

class OrderDetailsForm extends StatefulWidget {
  @override
  _OrderDetailsFormState createState() => _OrderDetailsFormState();
}

class _OrderDetailsFormState extends State<OrderDetailsForm> {
  final TextEditingController _deviceModelController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  final List<String> _problems = [];
  String? _selectedOrderStatus;

  final List<String> _orderStatusOptions = [
    'Pending',
    'In Progress',
    'Completed',
    'Cancelled',
  ];

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
                "Order Status",
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
                items: _orderStatusOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedOrderStatus = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Device Model:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _deviceModelController,
                decoration: InputDecoration(
                  labelText: 'Enter Model',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.devices),
                ),
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
      ),
    );
  }
}

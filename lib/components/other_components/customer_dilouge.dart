import 'package:flutter/material.dart';

class CustomerDialog extends StatelessWidget {
  final String receiverName;
  final ValueChanged<bool> onSelectCustomer;

  const CustomerDialog({
    super.key,
    required this.receiverName,
    required this.onSelectCustomer,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text(
            'Search Results',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Receiver: ${receiverName.isNotEmpty ? receiverName : 'No value entered'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        isSelected = value!;
                      });
                    },
                  ),
                  const Text('Select this customer'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                onSelectCustomer(isSelected);
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(color: Colors.pink)),
            ),
          ],
        );
      },
    );
  }
}
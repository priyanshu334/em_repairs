import 'package:flutter/material.dart';

class Accessories extends StatefulWidget {
  const Accessories({super.key});

  @override
  State<Accessories> createState() => _AccessoriesState();
}

class _AccessoriesState extends State<Accessories> {
  // Define a map to manage the state of checkboxes for each accessory
  final Map<String, String> _accessorySelections = {
    "Power Adapter": "None",
    "Keyboard/Mouse": "None",
    "Other Device": "None",
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Accessories",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 20),
          _buildAccessoryRow("Power Adapter"),
          const SizedBox(height: 20),
          _buildAccessoryRow("Keyboard/Mouse"),
          const SizedBox(height: 20),
          _buildAccessoryRow("Other Device"),
        ],
      ),
    );
  }

  Widget _buildAccessoryRow(String accessoryName) {
    return Row(
      children: [
        Text(
          accessoryName,
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        Row(
          children: [
            const Text("Yes"),
            Checkbox(
              value: _accessorySelections[accessoryName] == "Yes",
              onChanged: (value) {
                setState(() {
                  _accessorySelections[accessoryName] = value! ? "Yes" : "None";
                });
              },
            ),
            const Text("No"),
            Checkbox(
              value: _accessorySelections[accessoryName] == "No",
              onChanged: (value) {
                setState(() {
                  _accessorySelections[accessoryName] = value! ? "No" : "None";
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

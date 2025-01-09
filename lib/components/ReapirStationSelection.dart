import 'package:flutter/material.dart';

class RepairStationSelection extends StatelessWidget {
  final bool isInHouse;
  final bool isServiceCenter;
  final ValueChanged<bool?> onInHouseChanged;
  final ValueChanged<bool?> onServiceCenterChanged;

  const RepairStationSelection({
    Key? key,
    required this.isInHouse,
    required this.isServiceCenter,
    required this.onInHouseChanged,
    required this.onServiceCenterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Repair Station:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: isInHouse,
              onChanged: onInHouseChanged,
            ),
            const Text("In-house"),
            Checkbox(
              value: isServiceCenter,
              onChanged: onServiceCenterChanged,
            ),
            const Text("Service Center"),
          ],
        ),
      ],
    );
  }
}

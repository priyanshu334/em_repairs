import 'package:flutter/material.dart';

class LocationSelection extends StatelessWidget {
  final bool inHouse;
  final bool serviceCenter;
  final Function(bool?) onInHouseChanged;
  final Function(bool?) onServiceCenterChanged;

  const LocationSelection({
    Key? key,
    required this.inHouse,
    required this.serviceCenter,
    required this.onInHouseChanged,
    required this.onServiceCenterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Other Locations:"),
        const SizedBox(height: 10),
        Row(
          children: [
            Checkbox(
              value: inHouse,
              onChanged: onInHouseChanged,
            ),
            const Text("In-house"),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: serviceCenter,
              onChanged: onServiceCenterChanged,
            ),
            const Text("Service Center"),
          ],
        ),
      ],
    );
  }
}
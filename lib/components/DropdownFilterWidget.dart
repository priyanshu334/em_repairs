import 'package:flutter/material.dart';

class DropdownFilterWidget<T> extends StatelessWidget {
  final String hintText;
  final List<T> items;
  final Function(T?)? onChanged;

  const DropdownFilterWidget({
    Key? key,
    required this.hintText,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      hint: Text(hintText),
      items: items.map<DropdownMenuItem<T>>((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()), // Customize this based on the object
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

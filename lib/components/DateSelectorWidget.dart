import 'package:flutter/material.dart';

class DateSelectorWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final Function() onSelectDate;

  const DateSelectorWidget({
    Key? key,
    this.selectedDate,
    required this.onSelectDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: selectedDate == null
                  ? 'Select Date (dd/mm/yyyy)'
                  : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today, color: Colors.blueAccent),
                onPressed: onSelectDate,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

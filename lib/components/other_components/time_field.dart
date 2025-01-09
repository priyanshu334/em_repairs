import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Add intl package for date formatting

class TimeFeild extends StatefulWidget {
  const TimeFeild({super.key});

  @override
  State<TimeFeild> createState() => _TimeFeildState();
}

class _TimeFeildState extends State<TimeFeild> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Function to format the time using intl package
  String _formatTime(TimeOfDay time) {
    final DateFormat formatter = DateFormat('hh:mm a');
    final DateTime dateTime = DateTime(0, 0, 0, time.hour, time.minute);
    return formatter.format(dateTime);  // Formats the time
  }

  // Function to open the time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Getting screen size
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),  // Adjust padding based on screen width
      child: SingleChildScrollView(  // Makes the Column scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Time",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04),  // Adjust padding inside the container
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Text(
                "Current Time: ${_formatTime(_selectedTime)}",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,  // Makes the button take the full width of the screen
              child: ElevatedButton(
                onPressed: () => _selectTime(context),  // Opens time picker
                child: const Text('Select Time'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Add intl package for date formatting

class DateFeild extends StatefulWidget {
  const DateFeild({super.key});

  @override
  State<DateFeild> createState() => _DateFeildState();
}

class _DateFeildState extends State<DateFeild> {
  DateTime _selectedDate = DateTime.now();

  // Function to format the date using intl package
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);  // Formats the date
  }

  // Function to open the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
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
              "Select Date",
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
                "Current Date: ${_formatDate(_selectedDate)}",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,  // Makes the button take the full width of the screen
              child: ElevatedButton(
                onPressed: () => _selectDate(context),  // Opens date picker
                child: const Text('Select Date'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
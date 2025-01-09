import 'package:flutter/material.dart';

class FiltersSection extends StatefulWidget {
  final Function(String)? onCustomerNameChanged;
  final Function(String?)? onOperatorChanged;
  final Function(String?)? onOrderChanged;
  final Function(String?)? onLocationChanged;
  final VoidCallback? onTodayPressed;
  final VoidCallback? onSearchPressed;

  const FiltersSection({
    Key? key,
    this.onCustomerNameChanged,
    this.onOperatorChanged,
    this.onOrderChanged,
    this.onLocationChanged,
    this.onTodayPressed,
    this.onSearchPressed,
  }) : super(key: key);

  @override
  _FiltersSectionState createState() => _FiltersSectionState();
}

class _FiltersSectionState extends State<FiltersSection> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter Customer Name',
            suffixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
          onChanged: widget.onCustomerNameChanged,
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
          hint: Text('Select Operator'),
          items: <String>['Operator 1', 'Operator 2', 'Operator 3']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: widget.onOperatorChanged,
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
          hint: Text('Select Order'),
          items: <String>['Order 1', 'Order 2', 'Order 3']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: widget.onOrderChanged,
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
          hint: Text('Select Repair Location'),
          items: <String>['Location 1', 'Location 2', 'Location 3']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: widget.onLocationChanged,
        ),
        SizedBox(height: 16),
        Row(
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
                    onPressed: () => _selectDate(context),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: widget.onTodayPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade600,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Today",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.white),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: widget.onSearchPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Search",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

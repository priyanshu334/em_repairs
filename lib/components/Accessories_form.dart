import 'package:flutter/material.dart';

class AccessoriesForm extends StatefulWidget {
  final Function({
    required bool powerAdapterChecked,
    required bool keyboardChecked,
    required bool mouseChecked,
    required bool warrantyChecked,
    required String accessories,
    required String details,
    required DateTime? warrantyDate,
  }) onDataChanged; // Define a callback to pass data to the parent

  const AccessoriesForm({Key? key, required this.onDataChanged}) : super(key: key);

  @override
  _AccessoriesFormState createState() => _AccessoriesFormState();
}

class _AccessoriesFormState extends State<AccessoriesForm> {
  bool isPowerAdapterChecked = false;
  bool isKeyboardChecked = false;
  bool isMouseChecked = false;
  bool isWarrantyChecked = false;
  TextEditingController accessoryController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _sendDataToParent() {
    widget.onDataChanged(
      powerAdapterChecked: isPowerAdapterChecked,
      keyboardChecked: isKeyboardChecked,
      mouseChecked: isMouseChecked,
      warrantyChecked: isWarrantyChecked,
      accessories: accessoryController.text,
      details: detailsController.text,
      warrantyDate: selectedDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Accessories List",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 16),
          _buildCheckBoxRow(
            title: "Power Adapter",
            value: isPowerAdapterChecked,
            onChanged: (value) => setState(() {
              isPowerAdapterChecked = value!;
            }),
            icon: Icons.power,
          ),
          _buildCheckBoxRow(
            title: "Keyboard",
            value: isKeyboardChecked,
            onChanged: (value) => setState(() {
              isKeyboardChecked = value!;
            }),
            icon: Icons.keyboard,
          ),
          _buildCheckBoxRow(
            title: "Mouse",
            value: isMouseChecked,
            onChanged: (value) => setState(() {
              isMouseChecked = value!;
            }),
            icon: Icons.mouse,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: accessoryController,
            label: "Other Accessories (comma-separated)",
            icon: Icons.add_circle_outline,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: detailsController,
            label: "Additional Details",
            icon: Icons.info_outline,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: isWarrantyChecked,
                onChanged: (value) => setState(() {
                  isWarrantyChecked = value!;
                }),
              ),
              Text(
                "Device on warranty",
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              InkWell(
                onTap: () => _selectDate(context),
                child: Row(
                  children: [
                    Text(
                      selectedDate != null
                          ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                          : "Select Date",
                      style: TextStyle(
                          color: selectedDate != null
                              ? Colors.black
                              : Colors.grey),
                    ),
                    Icon(Icons.calendar_today,
                        color:
                            selectedDate != null ? Colors.black : Colors.grey),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _sendDataToParent, // Send data to the parent when pressed
            child: Text("Send Data to Parent"),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckBoxRow({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required IconData icon,
  }) {
    return CheckboxListTile(
      title: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 10),
          Text(title, style: TextStyle(fontSize: 16)),
        ],
      ),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AccessoriesForm extends StatefulWidget {
  final Function(Map<String, dynamic> accessoryData)? onSubmit;

  const AccessoriesForm({Key? key, this.onSubmit}) : super(key: key);

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

  // Store additional accessories (other than predefined ones like power adapter)
  List<String> otherAccessories = [];

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


  void _submitForm() {
    final String accessoryName = accessoryController.text;
    final String additionalDetails = detailsController.text;
    final bool warranty = isWarrantyChecked;
    final DateTime? warrantyDate = selectedDate;

    // Generate a UUID for the accessory
    String accessoryId = Uuid().v4(); // Generate a unique ID for the accessory

    // Create an accessory data map
    Map<String, dynamic> newAccessory = {
      'id': accessoryId,
      'additionalDetails': additionalDetails,
      'isWarrantyChecked': warranty,
      'warrantyDate': warrantyDate,
      'isPowerAdapterChecked': isPowerAdapterChecked,
      'isKeyboardChecked': isKeyboardChecked,
      'isMouseChecked': isMouseChecked,
      'otherAccessories': otherAccessories,
    };

    // Call the onSubmit callback with the accessory data
    if (widget.onSubmit != null) {
      widget.onSubmit!(newAccessory);
    }

    // Clear the form after submission
    setState(() {
      isPowerAdapterChecked = false;
      isKeyboardChecked = false;
      isMouseChecked = false;
      isWarrantyChecked = false;
      accessoryController.clear();
      detailsController.clear();
      selectedDate = null;
      otherAccessories.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            "Accessories List",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 16),

          // Checkbox for Power Adapter
          _buildCheckBoxRow(
            title: "Power Adapter",
            value: isPowerAdapterChecked,
            onChanged: (value) {
              setState(() {
                isPowerAdapterChecked = value!;
              });
            },
            icon: Icons.power,
          ),

          // Checkbox for Keyboard
          _buildCheckBoxRow(
            title: "Keyboard",
            value: isKeyboardChecked,
            onChanged: (value) {
              setState(() {
                isKeyboardChecked = value!;
              });
            },
            icon: Icons.keyboard,
          ),

          // Checkbox for Mouse
          _buildCheckBoxRow(
            title: "Mouse",
            value: isMouseChecked,
            onChanged: (value) {
              setState(() {
                isMouseChecked = value!;
              });
            },
            icon: Icons.mouse,
          ),

          SizedBox(height: 16),

          // Text Field for Other Accessories
          _buildTextField(
            controller: accessoryController,
            label: "Other Accessories",
            icon: Icons.add_circle_outline,
          ),

          SizedBox(height: 16),

          // Text Field for Additional Details
          _buildTextField(
            controller: detailsController,
            label: "Additional Details",
            icon: Icons.info_outline,
          ),

          SizedBox(height: 16),

          // Warranty Checkbox and Date Picker
          Row(
            children: [
              Checkbox(
                value: isWarrantyChecked,
                onChanged: (value) {
                  setState(() {
                    isWarrantyChecked = value!;
                  });
                },
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

          // Submit Button
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 14),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 2),
              child: Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build each checkbox row with an icon
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

  // Function to build a text field with an icon
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

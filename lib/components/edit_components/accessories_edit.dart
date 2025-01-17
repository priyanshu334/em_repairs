import 'package:flutter/material.dart';
import 'package:em_repairs/models/accessories_model.dart';
import 'package:em_repairs/provider/accesories_provider.dart';
import 'package:provider/provider.dart';

class AccessoriesForm extends StatefulWidget {
  final Function(AccessoriesModel accessory)? onSubmit;
  final AccessoriesModel? existingAccessory; // New field to pass an existing accessory

  const AccessoriesForm({Key? key, this.onSubmit, this.existingAccessory})
      : super(key: key);

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

  @override
  void initState() {
    super.initState();

    // If an existing accessory is provided, prepopulate the form fields
    if (widget.existingAccessory != null) {
      final accessory = widget.existingAccessory!;
      accessoryController.text = accessory.otherAccessories.join(', ');
      detailsController.text = accessory.additionalDetails!;
      isPowerAdapterChecked = accessory.isPowerAdapterChecked;
      isKeyboardChecked = accessory.isKeyboardChecked;
      isMouseChecked = accessory.isMouseChecked;
      isWarrantyChecked = accessory.isWarrantyChecked;
      selectedDate = accessory.warrantyDate;
      otherAccessories = List.from(accessory.otherAccessories);
    }
  }

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

  void _submitForm() async {
    final String accessoryName = accessoryController.text;
    final String additionalDetails = detailsController.text;
    final bool warranty = isWarrantyChecked;
    final DateTime? warrantyDate = selectedDate;

    // Create an instance of AccessoriesModel
    AccessoriesModel newAccessory = AccessoriesModel(
      additionalDetails: additionalDetails,
      isWarrantyChecked: warranty,
      warrantyDate: warrantyDate,
      isPowerAdapterChecked: isPowerAdapterChecked,
      isKeyboardChecked: isKeyboardChecked,
      isMouseChecked: isMouseChecked,
      otherAccessories: List<String>.from(otherAccessories),  // Save other accessories
    );

    if (widget.existingAccessory != null) {
      // If the accessory exists (i.e., we are editing), update it
      newAccessory = newAccessory.copyWith(id: widget.existingAccessory!.id);
      
      // Update the accessory using the AccessoriesProvider
      await context.read<AccessoriesProvider>().updateAccessories(newAccessory);
    } else {
      // Otherwise, create a new accessory
      await context.read<AccessoriesProvider>().saveAccessories(newAccessory);
    }

    // Optional: Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Accessory ${widget.existingAccessory != null ? 'updated' : 'added'} successfully!')),
    );

    // Send the saved or updated model back to the parent via the onSubmit callback
    if (widget.onSubmit != null) {
      final savedAccessory = widget.existingAccessory != null
          ? newAccessory // Return the updated model
          : context.read<AccessoriesProvider>().accessories.last; // For new model
      widget.onSubmit!(savedAccessory);  // Send the saved or updated model
    }
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
            widget.existingAccessory != null ? "Update Accessory" : "Accessories List",
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
                widget.existingAccessory != null ? "Update" : "Submit",
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

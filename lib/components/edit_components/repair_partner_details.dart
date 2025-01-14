import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:em_repairs/models/repair_partner_detail.dart';
import 'package:em_repairs/provider/repair_partner_provider.dart';

class RepairPartnerDetails extends StatefulWidget {
  final String? repairPartnerId; // ID passed from parent

  const RepairPartnerDetails({Key? key, this.repairPartnerId}) : super(key: key);

  @override
  State<RepairPartnerDetails> createState() => _RepairPartnerDetailsState();
}

class _RepairPartnerDetailsState extends State<RepairPartnerDetails> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  bool _isInHouse = false;
  bool _isServiceCenter = false;
  String? _selectedOperator;
  String? _selectedServiceCenter;
  DateTime? _pickupDate;
  String? _pickupTime;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRepairPartnerDetails();
  }

  Future<void> _loadRepairPartnerDetails() async {
    if (widget.repairPartnerId != null) {
      try {
        final provider =
            Provider.of<RepairPartnerDetailsProvider>(context, listen: false);

        final details = await provider.getRepairPartnerDetailById(widget.repairPartnerId!);

        setState(() {
          _isInHouse = details.isInHouse ?? false;
          _isServiceCenter = details.isServiceCenter ?? false;
          _selectedOperator = details.selectedOperator;
          _selectedServiceCenter = details.selectedServiceCenter;
          _pickupDate = details.pickupDate;
          _pickupTime = details.pickupTime;
          _isLoading = false;
        });
      } catch (e) {
        debugPrint('Error loading repair partner details: $e');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectPickupDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _pickupDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _pickupDate) {
      setState(() {
        _pickupDate = pickedDate;
      });
    }
  }

  void _saveDetails(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedDetails = RepairPartnerDetailsModel(
        id: widget.repairPartnerId ?? '', // Use existing ID or generate new
        isInHouse: _isInHouse,
        isServiceCenter: _isServiceCenter,
        selectedOperator: _selectedOperator,
        selectedServiceCenter: _selectedServiceCenter,
        pickupDate: _pickupDate,
        pickupTime: _pickupTime,
      );

      final provider =
          Provider.of<RepairPartnerDetailsProvider>(context, listen: false);

      if (widget.repairPartnerId != null) {
        // Update existing record
        provider.updateRepairPartnerDetails(updatedDetails);
      } else {
        // Add new record
        provider.addRepairPartnerDetails(updatedDetails);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Repair Partner Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isInHouse,
                      onChanged: (value) {
                        setState(() {
                          _isInHouse = value ?? false;
                        });
                      },
                    ),
                    const Text("In-House"),
                    const SizedBox(width: 20),
                    Checkbox(
                      value: _isServiceCenter,
                      onChanged: (value) {
                        setState(() {
                          _isServiceCenter = value ?? false;
                        });
                      },
                    ),
                    const Text("Service Center"),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedOperator,
                  onChanged: (value) {
                    setState(() {
                      _selectedOperator = value;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: "Operator 1",
                      child: Text("Operator 1"),
                    ),
                    DropdownMenuItem(
                      value: "Operator 2",
                      child: Text("Operator 2"),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: "Select Operator",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedServiceCenter,
                  onChanged: (value) {
                    setState(() {
                      _selectedServiceCenter = value;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: "Center 1",
                      child: Text("Center 1"),
                    ),
                    DropdownMenuItem(
                      value: "Center 2",
                      child: Text("Center 2"),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: "Select Service Center",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _pickupDate != null
                            ? "Pickup Date: ${_pickupDate!.toLocal().toString().split(' ')[0]}"
                            : "No date selected",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: _selectPickupDate,
                      child: const Text("Select Date"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _pickupTime,
                  onChanged: (value) {
                    _pickupTime = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Pickup Time",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: const Icon(Icons.access_time),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _saveDetails(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Save Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:em_repairs/models/estimate_form.dart';
import 'package:em_repairs/provider/estimate_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EstimateForm extends StatefulWidget {
  final String? estimateId; // ID of the estimate to be updated

  const EstimateForm({
    Key? key,
    this.estimateId,  // Receiving estimate ID from parent
  }) : super(key: key);

  @override
  State<EstimateForm> createState() => _EstimateFormState();
}

class _EstimateFormState extends State<EstimateForm> {
  final TextEditingController repairCostController = TextEditingController();
  final TextEditingController advancePaidController = TextEditingController();
  DateTime? pickupDate;
  String? pickupTime; // Using String for pickupTime as per the model

  late EstimateProvider _estimateProvider;

  @override
  void initState() {
    super.initState();
    _estimateProvider = Provider.of<EstimateProvider>(context, listen: false);
    if (widget.estimateId != null) {
      // Fetch the estimate data based on the provided ID
      fetchEstimate();
    }
  }

  // Fetch the estimate using the passed estimateId
  Future<void> fetchEstimate() async {
    try {
      final EstimateModel estimate = await _estimateProvider.getEstimateById(widget.estimateId!);
      setState(() {
        repairCostController.text = estimate.repairCost.toString();
        advancePaidController.text = estimate.advancePaid.toString();
        pickupDate = estimate.pickupDate;
        pickupTime = estimate.pickupTime;
      });
    } catch (e) {
      debugPrint('Error fetching estimate: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.estimateId == null ? "Create Estimate" : "Update Estimate",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: repairCostController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Repair Cost",
                  hintText: "Enter Price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: advancePaidController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Advance Paid",
                  hintText: "Enter Price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.payment),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Pickup Date",
                        hintText: pickupDate == null
                            ? "dd/mm/yy"
                            : "${pickupDate!.day}/${pickupDate!.month}/${pickupDate!.year}",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            pickupDate = selectedDate;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          pickupDate = selectedDate;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Pickup Time",
                        hintText: pickupTime ?? "hh:mm",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onTap: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          setState(() {
                            pickupTime = '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}';
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          pickupTime = '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}';
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (repairCostController.text.isNotEmpty &&
                      advancePaidController.text.isNotEmpty &&
                      pickupDate != null &&
                      pickupTime != null) {
                    // Create or Update Estimate
                    EstimateModel updatedEstimate = EstimateModel(
                      id: widget.estimateId, // Use the existing ID or leave null for creation
                      repairCost: double.tryParse(repairCostController.text) ?? 0.0,
                      advancePaid: double.tryParse(advancePaidController.text) ?? 0.0,
                      pickupDate: pickupDate!,
                      pickupTime: pickupTime!, // Set as a String
                    );

                    // Update or create the estimate using the provider
                    if (widget.estimateId != null) {
                      // Update the existing estimate
                      await _estimateProvider.updateEstimate(updatedEstimate);
                    } else {
                      // Create a new estimate
                      await _estimateProvider.addEstimate(updatedEstimate);
                    }

                    // Optionally close the form or reset the fields
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    widget.estimateId == null ? "Create Estimate" : "Update Estimate",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

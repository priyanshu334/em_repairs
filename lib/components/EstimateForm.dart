import 'package:em_repairs/models/estimate_form.dart';
import 'package:em_repairs/provider/estimate_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EstimateForm extends StatefulWidget {
  final Function(EstimateModel newEstimate) onEstimateAdded; // Updated callback to pass the entire EstimateModel

  const EstimateForm({Key? key, required this.onEstimateAdded}) : super(key: key);

  @override
  State<EstimateForm> createState() => _EstimateFormState();
}

class _EstimateFormState extends State<EstimateForm> {
  final TextEditingController repairCostController = TextEditingController();
  final TextEditingController advancePaidController = TextEditingController();
  DateTime? pickupDate;
  TimeOfDay? pickupTime;

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
              const Text(
                "Estimates",
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
                        hintText: pickupTime == null
                            ? "hh:mm"
                            : "${pickupTime!.hour}:${pickupTime!.minute.toString().padLeft(2, '0')}",
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
                            pickupTime = selectedTime;
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
                          pickupTime = selectedTime;
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
                    // Create the EstimateModel
                    EstimateModel newEstimate = EstimateModel(
                      repairCost: double.tryParse(repairCostController.text) ?? 0.0,
                      advancePaid: double.tryParse(advancePaidController.text) ?? 0.0,
                      pickupDate: pickupDate!,
                      pickupTime: pickupTime!,
                    );

                    // Call addEstimate method from EstimateProvider to save the estimate
                    await Provider.of<EstimateProvider>(context, listen: false)
                        .addEstimate(newEstimate);

                    // Optionally, pass the entire estimate model back to the parent
                    widget.onEstimateAdded(newEstimate);

                    // Show success Snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Estimate saved successfully!',
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                      ),
                    );

                    // Reset fields after saving
                    repairCostController.clear();
                    advancePaidController.clear();
                    setState(() {
                      pickupDate = null;
                      pickupTime = null;
                    });
                  } else {
                    // Show error Snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Please fill in all fields.',
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    "Save Data",
                    style: TextStyle(
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

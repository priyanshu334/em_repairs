import 'package:flutter/material.dart';

class EstimateForm extends StatefulWidget {
  final Function({
    required String repairCost,
    required String advancePaid,
    required DateTime? pickupDate,
    required TimeOfDay? pickupTime,
  }) onFormChange;

  const EstimateForm({Key? key, required this.onFormChange}) : super(key: key);

  @override
  State<EstimateForm> createState() => _EstimateFormState();
}

class _EstimateFormState extends State<EstimateForm> {
  final TextEditingController repairCostController = TextEditingController();
  final TextEditingController advancePaidController = TextEditingController();
  DateTime? pickupDate;
  TimeOfDay? pickupTime;

  void _notifyParent() {
    widget.onFormChange(
      repairCost: repairCostController.text,
      advancePaid: advancePaidController.text,
      pickupDate: pickupDate,
      pickupTime: pickupTime,
    );
  }

  @override
  void initState() {
    super.initState();
    // Notify the parent component whenever the controllers change
    repairCostController.addListener(_notifyParent);
    advancePaidController.addListener(_notifyParent);
  }

  @override
  void dispose() {
    repairCostController.dispose();
    advancePaidController.dispose();
    super.dispose();
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
                          _notifyParent();
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
                        _notifyParent();
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
                          _notifyParent();
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
                        _notifyParent();
                      }
                    },
                    icon: const Icon(Icons.access_time),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

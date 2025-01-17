import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:em_repairs/components/ReapirStationSelection.dart';
import 'package:em_repairs/components/service_center_details.dart';
import 'package:em_repairs/models/repair_partner_detail.dart';
import 'package:em_repairs/provider/repair_partner_provider.dart';
import 'package:em_repairs/provider/service_center_provider.dart';
import 'package:em_repairs/provider/service_provider.dart';
import 'package:uuid/uuid.dart';

class RepairPartnerDetail extends StatefulWidget {
  final Function(RepairPartnerDetailsModel details) onDetailsChanged;
  final RepairPartnerDetailsModel? existingDetails;

  const RepairPartnerDetail({Key? key, required this.onDetailsChanged, this.existingDetails})
      : super(key: key);

  @override
  _RepairPartnerDetailsState createState() => _RepairPartnerDetailsState();
}

class _RepairPartnerDetailsState extends State<RepairPartnerDetail> {
  bool isInHouse = false;
  bool isServiceCenter = false;
  String? selectedServiceCenter;
  String? selectedOperator;
  DateTime? pickupDate;
  TimeOfDay? pickupTime;
  bool isUpdateMode = false;

  @override
  void initState() {
    super.initState();

    if (widget.existingDetails != null) {
      isUpdateMode = true;
      isInHouse = widget.existingDetails!.isInHouse;
      isServiceCenter = widget.existingDetails!.isServiceCenter;
      selectedServiceCenter = widget.existingDetails!.selectedServiceCenter;
      selectedOperator = widget.existingDetails!.selectedOperator;
      pickupDate = widget.existingDetails!.pickupDate;
      pickupTime = widget.existingDetails!.pickupTime != null
          ? TimeOfDay.fromDateTime(DateTime.parse(widget.existingDetails!.pickupTime!))
          : null;
    }

    final serviceCenterProvider = Provider.of<ServiceCenterProvider>(context, listen: false);
    final serviceProvider = Provider.of<ServiceProviderProvider>(context, listen: false);

    serviceCenterProvider.fetchServiceCenters();
    serviceProvider.fetchServiceProviders();
  }

  void _notifyParent(RepairPartnerDetailsModel? details) {
    if (details != null) {
      widget.onDetailsChanged(details);
    }
  }

  void _saveDetails() async {
    if (!isInHouse && !isServiceCenter) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select either In-House or Service Center.")),
      );
      return;
    }

    if (isInHouse && selectedOperator == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an operator for In-House repair.")),
      );
      return;
    }

    if (isServiceCenter && selectedServiceCenter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a service center.")),
      );
      return;
    }

    if (isServiceCenter && pickupDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a pickup date.")),
      );
      return;
    }

    // Format pickup time
    String? formattedPickupTime;
    if (pickupTime != null) {
      formattedPickupTime = pickupTime!.format(context);
    }

    try {
      final details = RepairPartnerDetailsModel(
        id: isUpdateMode ? widget.existingDetails!.id : const Uuid().v4(),
        isInHouse: isInHouse,
        isServiceCenter: isServiceCenter,
        selectedServiceCenter: selectedServiceCenter,
        selectedOperator: selectedOperator,
        pickupDate: pickupDate,
        pickupTime: formattedPickupTime,
      );

      final repairPartnerDetailsProvider = Provider.of<RepairPartnerDetailsProvider>(context, listen: false);

      if (isUpdateMode) {
        await repairPartnerDetailsProvider.updateRepairPartnerDetails(details);
      } else {
        await repairPartnerDetailsProvider.addRepairPartnerDetails(details);
      }

      _notifyParent(details);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Details saved successfully!")),
      );
    } catch (e) {
      debugPrint("Error saving details: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save details. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceCenterProvider = Provider.of<ServiceCenterProvider>(context);
    final serviceProvider = Provider.of<ServiceProviderProvider>(context);

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
                "Repair Partner Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 16),
              RepairStationSelection(
                isInHouse: isInHouse,
                isServiceCenter: isServiceCenter,
                onInHouseChanged: (value) {
                  setState(() {
                    isInHouse = value!;
                    if (isInHouse) {
                      isServiceCenter = false;
                      selectedOperator = null;
                    }
                  });
                },
                onServiceCenterChanged: (value) {
                  setState(() {
                    isServiceCenter = value!;
                    if (isServiceCenter) {
                      isInHouse = false;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              if (isInHouse) ...[
                const Text("Select Operator", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedOperator,
                  onChanged: (value) {
                    setState(() {
                      selectedOperator = value;
                    });
                  },
                  items: serviceProvider.serviceProviders.map((operator) {
                    return DropdownMenuItem(
                      value: operator.name,
                      child: Text(operator.name),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (isServiceCenter)
                ServiceCenterDetails(
                  isServiceCenter: isServiceCenter,
                  serviceCenters: serviceCenterProvider.serviceCenters.map((e) => e.name).toList(),
                  selectedServiceCenter: selectedServiceCenter,
                  pickupDate: pickupDate,
                  pickupTime: pickupTime,
                  onServiceCenterChanged: (value) {
                    setState(() {
                      selectedServiceCenter = value;
                    });
                  },
                  onDatePicked: (selectedDate) {
                    setState(() {
                      pickupDate = selectedDate;
                    });
                  },
                  onTimePicked: (selectedTime) {
                    setState(() {
                      pickupTime = selectedTime;
                    });
                  },
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade600,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Save Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

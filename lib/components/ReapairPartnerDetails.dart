import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:em_repairs/components/ReapirStationSelection.dart';
import 'package:em_repairs/components/service_center_details.dart';
import 'package:em_repairs/provider/service_center_provider.dart';
import 'package:em_repairs/provider/service_provider.dart';

class RepairPartnerDetails extends StatefulWidget {
  final Function({
    required bool isInHouse,
    required bool isServiceCenter,
    String? selectedServiceCenter,
    String? selectedOperator,
    DateTime? pickupDate,
    TimeOfDay? pickupTime,
  }) onDetailsChanged;

  const RepairPartnerDetails({Key? key, required this.onDetailsChanged})
      : super(key: key);

  @override
  _RepairPartnerDetailsState createState() => _RepairPartnerDetailsState();
}

class _RepairPartnerDetailsState extends State<RepairPartnerDetails> {
  bool isInHouse = false;
  bool isServiceCenter = false;
  String? selectedServiceCenter;
  String? selectedOperator;
  DateTime? pickupDate;
  TimeOfDay? pickupTime;

  @override
  void initState() {
    super.initState();
    // Fetch service centers and operators on initialization
    final serviceCenterProvider =
        Provider.of<ServiceCenterProvider>(context, listen: false);
    final serviceProvider =
        Provider.of<ServiceProviderProvider>(context, listen: false);

    serviceCenterProvider.fetchServiceCenters();
    serviceProvider.fetchServiceProviders();
  }

  void _notifyParent() {
    widget.onDetailsChanged(
      isInHouse: isInHouse,
      isServiceCenter: isServiceCenter,
      selectedServiceCenter: selectedServiceCenter,
      selectedOperator: selectedOperator,
      pickupDate: pickupDate,
      pickupTime: pickupTime,
    );
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
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
                    _notifyParent();
                  });
                },
                onServiceCenterChanged: (value) {
                  setState(() {
                    isServiceCenter = value!;
                    if (isServiceCenter) {
                      isInHouse = false;
                    }
                    _notifyParent();
                  });
                },
              ),
              const SizedBox(height: 16),
              if (isInHouse) ...[
                Row(
                  children: [
                    Icon(Icons.hail_outlined),
                    const SizedBox(width: 10),
                    const Text(
                      "Select Operator",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedOperator,
                  onChanged: (value) {
                    setState(() {
                      selectedOperator = value;
                      _notifyParent();
                    });
                  },
                  items: serviceProvider.serviceProviders.map((operator) {
                    return DropdownMenuItem(
                      value: operator.name,
                      child: Text(operator.name),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (isServiceCenter)
                ServiceCenterDetails(
                  isServiceCenter: isServiceCenter,
                  serviceCenters: serviceCenterProvider.serviceCenters
                      .map((e) => e.name)
                      .toList(),
                  selectedServiceCenter: selectedServiceCenter,
                  pickupDate: pickupDate,
                  pickupTime: pickupTime,
                  onServiceCenterChanged: (value) {
                    setState(() {
                      selectedServiceCenter = value;
                      _notifyParent();
                    });
                  },
                  onDatePicked: (selectedDate) {
                    setState(() {
                      pickupDate = selectedDate;
                      _notifyParent();
                    });
                  },
                  onTimePicked: (selectedTime) {
                    setState(() {
                      pickupTime = selectedTime;
                      _notifyParent();
                    });
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

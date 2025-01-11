import 'package:em_repairs/components/ReapirStationSelection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'service_center_details.dart';
import 'contact_actions.dart';

class RepairPartnerDetails extends StatefulWidget {
  @override
  _RepairPartnerDetailsState createState() => _RepairPartnerDetailsState();
}

class _RepairPartnerDetailsState extends State<RepairPartnerDetails> {
  bool isInHouse = false;
  bool isServiceCenter = false;
  String? selectedServiceCenter;
  DateTime? pickupDate;
  TimeOfDay? pickupTime;

  final List<String> serviceCenters = ["Center 1", "Center 2", "Center 3"];

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
                    if (isInHouse) isServiceCenter = false;
                  });
                },
                onServiceCenterChanged: (value) {
                  setState(() {
                    isServiceCenter = value!;
                    if (isServiceCenter) isInHouse = false;
                  });
                },
              ),
              const SizedBox(height: 16),
              ServiceCenterDetails(
                isServiceCenter: isServiceCenter,
                serviceCenters: serviceCenters,
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
          
            ],
          ),
        ),
      ),
    );
  }
}

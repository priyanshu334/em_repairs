import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// ContactActions Widget
class ContactActions extends StatefulWidget {
  @override
  _ContactActionsState createState() => _ContactActionsState();
}

class _ContactActionsState extends State<ContactActions> {
  int _selectedIndex = -1;

  void _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '1234567890');
    if (!await launchUrl(phoneUri)) {
      throw 'Could not launch $phoneUri';
    }
  }

  void _launchWhatsApp() async {
    final Uri whatsappUri = Uri.parse('https://wa.me/1234567890');
    if (!await launchUrl(whatsappUri)) {
      throw 'Could not launch $whatsappUri';
    }
  }

  void _launchSMS() async {
    final Uri messageUri = Uri(scheme: 'sms', path: '1234567890');
    if (!await launchUrl(messageUri)) {
      throw 'Could not launch $messageUri';
    }
  }

  void _onIconTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(
            context,
            icon: Icons.phone,
            label: 'Phone',
            onTap: () {
              _launchPhone();
              _onIconTap(0);
            },
            index: 0,
          ),
          _buildNavItem(
            context,
            icon: Icons.message,
            label: 'Message',
            onTap: () {
              _launchSMS();
              _onIconTap(1);
            },
            index: 1,
          ),
          _buildNavItem(
            context,
            icon: FontAwesomeIcons.whatsapp,
            label: 'WhatsApp',
            onTap: () {
              _launchWhatsApp();
              _onIconTap(2);
            },
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required int index,
  }) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal.shade200 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.teal.shade200.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.teal.shade300,
              size: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.teal.shade300,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ServiceCenterDetails Widget
class ServiceCenterDetails extends StatelessWidget {
  final bool isServiceCenter;
  final List<String> serviceCenters;
  final String? selectedServiceCenter;
  final DateTime? pickupDate;
  final TimeOfDay? pickupTime;
  final ValueChanged<String?> onServiceCenterChanged;
  final ValueChanged<DateTime?> onDatePicked;
  final ValueChanged<TimeOfDay?> onTimePicked;

  const ServiceCenterDetails({
    Key? key,
    required this.isServiceCenter,
    required this.serviceCenters,
    required this.selectedServiceCenter,
    required this.pickupDate,
    required this.pickupTime,
    required this.onServiceCenterChanged,
    required this.onDatePicked,
    required this.onTimePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isServiceCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: selectedServiceCenter,
            hint: const Text("Select Service Center"),
            onChanged: onServiceCenterChanged,
            items: serviceCenters.map((center) {
              return DropdownMenuItem(
                value: center,
                child: Text(center),
              );
            }).toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.location_city),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Pickup Date",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: pickupDate == null
                        ? "dd/mm/yy"
                        : "${pickupDate!.day}/${pickupDate!.month}/${pickupDate!.year}",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      onDatePicked(selectedDate);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    onDatePicked(selectedDate);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Pickup Time",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: pickupTime == null
                        ? "hh:mm"
                        : pickupTime!.format(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onTap: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      onTimePicked(selectedTime);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    onTimePicked(selectedTime);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ContactActions(), // ContactActions integrated
        ],
      ),
    );
  }
}

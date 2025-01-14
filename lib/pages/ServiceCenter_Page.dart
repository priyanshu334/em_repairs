import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:em_repairs/pages/help_page.dart';
import 'package:em_repairs/models/service_center_model.dart';
import 'package:em_repairs/provider/service_center_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceCenterPage extends StatefulWidget {
  const ServiceCenterPage({Key? key}) : super(key: key);

  @override
  _ServiceCenterPageState createState() => _ServiceCenterPageState();
}

class _ServiceCenterPageState extends State<ServiceCenterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  ServiceCenterModel? _editingServiceCenter;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ServiceCenterProvider>(context, listen: false);
    provider.fetchServiceCenters();
  }

  void _submitDetails(ServiceCenterProvider provider) {
    final name = _nameController.text;
    final number = _numberController.text;
    final address = _addressController.text;

    if (name.isNotEmpty && number.isNotEmpty && address.isNotEmpty) {
      final serviceCenter = ServiceCenterModel(
        id: _editingServiceCenter != null ? _editingServiceCenter!.id : 'unique()', // Use the existing ID if editing
        name: name,
        contactNumber: number,
        address: address,
      );

      if (_editingServiceCenter == null) {
        provider.addServiceCenter(serviceCenter);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Service Center Added: $name')));
      } else {
        provider.updateServiceCenter(serviceCenter);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Service Center Updated: $name')));
      }

      _clearFields();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
    }
  }

  void _clearFields() {
    _nameController.clear();
    _numberController.clear();
    _addressController.clear();
    setState(() {
      _editingServiceCenter = null; // Reset the editing state
    });
  }

  void _editServiceCenter(ServiceCenterProvider provider, ServiceCenterModel serviceCenter) {
    _nameController.text = serviceCenter.name;
    _numberController.text = serviceCenter.contactNumber;
    _addressController.text = serviceCenter.address;

    setState(() {
      _editingServiceCenter = serviceCenter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ServiceCenterProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Service Center",
        leadingIcon: Icons.build,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HelpPage()));
            },
          ),
        ],
      ),
      body: Padding(
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
                  "Service Center Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Service Center Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.business),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _numberController,
                  decoration: InputDecoration(
                    labelText: "Contact Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _submitDetails(provider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _clearFields,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.serviceCenters.length,
                    itemBuilder: (context, index) {
                      final serviceCenter = provider.serviceCenters[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(serviceCenter.name),
                          subtitle: Text(serviceCenter.contactNumber),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editServiceCenter(provider, serviceCenter);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  provider.removeServiceCenter(serviceCenter);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${serviceCenter.name} removed')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

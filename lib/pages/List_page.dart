import 'package:appwrite/appwrite.dart';
import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:em_repairs/pages/help_page.dart';
import 'package:em_repairs/models/service_provider_model.dart';
import 'package:em_repairs/provider/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isEditing = false;
  ServiceProviderModel? _editingServiceProvider;

  @override
  void initState() {
    super.initState();
    // Fetch data on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceProviderProvider>(context, listen: false).fetchServiceProviders();
    });
  }

  void _submitDetails(ServiceProviderProvider provider) {
    final name = _nameController.text.trim();
    final contactNo = _contactNoController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isNotEmpty && contactNo.isNotEmpty && description.isNotEmpty) {
      final serviceProvider = ServiceProviderModel(
        id: _isEditing ? _editingServiceProvider?.id : null, // Use the existing ID for editing
        name: name,
        contactNo: contactNo,
        description: description,
      );

      if (_isEditing) {
        provider.updateServiceProvider(serviceProvider);
      } else {
        provider.addServiceProvider(serviceProvider);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Service Provider Updated' : 'Service Provider Added: $name')),
      );

      _clearFields();
      setState(() {
        _isEditing = false;
        _editingServiceProvider = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  void _clearFields() {
    _nameController.clear();
    _contactNoController.clear();
    _descriptionController.clear();
  }

  void _editServiceProvider(ServiceProviderModel serviceProvider) {
    _nameController.text = serviceProvider.name;
    _contactNoController.text = serviceProvider.contactNo;
    _descriptionController.text = serviceProvider.description;
    setState(() {
      _isEditing = true;
      _editingServiceProvider = serviceProvider;
    });
  }

  void _deleteServiceProvider(ServiceProviderModel serviceProvider, ServiceProviderProvider provider) {
    provider.removeServiceProvider(serviceProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${serviceProvider.name} removed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ServiceProviderProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Service Providers",
        leadingIcon: Icons.business_center,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
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
                  "Service Provider Details",
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
                    labelText: "Provider Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _contactNoController,
                  decoration: InputDecoration(
                    labelText: "Contact Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.description),
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
                        child: Text(
                          _isEditing ? "Update" : "Submit",
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
                    itemCount: provider.serviceProviders.length,
                    itemBuilder: (context, index) {
                      final serviceProvider = provider.serviceProviders[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(serviceProvider.name),
                          subtitle: Text('${serviceProvider.contactNo} - ${serviceProvider.description}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editServiceProvider(serviceProvider),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteServiceProvider(serviceProvider, provider),
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

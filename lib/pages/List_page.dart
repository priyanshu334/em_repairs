import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<Map<String, dynamic>> _entries = [];
  int? _editingIndex;

  void _addEntry() {
    if (_nameController.text.isNotEmpty &&
        _serviceController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      final newEntry = {
        'name': _nameController.text,
        'service': _serviceController.text,
        'description': _descriptionController.text,
        'isScored': false,
      };

      setState(() {
        _entries.add(newEntry);
      });
      _clearFields();
    }
  }

  void _updateEntry() {
    if (_nameController.text.isNotEmpty &&
        _serviceController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _editingIndex != null) {
      setState(() {
        _entries[_editingIndex!] = {
          'name': _nameController.text,
          'service': _serviceController.text,
          'description': _descriptionController.text,
          'isScored': _entries[_editingIndex!]['isScored'],
        };
        _editingIndex = null;
      });
      _clearFields();
    }
  }

  void _toggleScoredStatus(int index) {
    setState(() {
      _entries[index]['isScored'] = !_entries[index]['isScored'];
    });
  }

  void _deleteEntry(int index) {
    setState(() {
      _entries.removeAt(index);
    });
  }

  void _clearFields() {
    _nameController.clear();
    _serviceController.clear();
    _descriptionController.clear();
  }

  void _setEditingEntry(int index) {
    setState(() {
      _nameController.text = _entries[index]['name'];
      _serviceController.text = _entries[index]['service'];
      _descriptionController.text = _entries[index]['description'];
      _editingIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Service Operator",
        leadingIcon: Icons.build,
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              // Add search functionality here
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
                  "Service Entries",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _nameController,
                  labelText: "Name",
                  icon: Icons.person,
                  
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _serviceController,
                  labelText: "Service",
                  icon: Icons.design_services,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  labelText: "Description",
                  icon: Icons.description,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _editingIndex == null ? _addEntry : _updateEntry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _editingIndex == null ? "Submit" : "Update",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.black),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Text(
                              entry['name'][0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            entry['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${entry['service']} - ${entry['description']}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  entry['isScored']
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: Colors.green,
                                ),
                                onPressed: () => _toggleScoredStatus(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _setEditingEntry(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteEntry(index),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serviceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

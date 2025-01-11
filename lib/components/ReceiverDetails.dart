import 'package:flutter/material.dart';

class ReceiverDetailsForm extends StatefulWidget {
  final Function(String name, bool isOwner, bool isStaff) onDataChanged; // Callback function

  const ReceiverDetailsForm({Key? key, required this.onDataChanged}) : super(key: key);

  @override
  _ReceiverDetailsFormState createState() => _ReceiverDetailsFormState();
}

class _ReceiverDetailsFormState extends State<ReceiverDetailsForm> {
  final TextEditingController _nameController = TextEditingController();
  bool isOwner = false;
  bool isStaff = false;

  void _clearFields() {
    _nameController.clear();
    setState(() {
      isOwner = false;
      isStaff = false;
    });
  }

  void _sendDataToParent() {
    // Send the form data to the parent using the callback
    widget.onDataChanged(_nameController.text.trim(), isOwner, isStaff);
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
                "Receiver Details",
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
                  labelText: "Enter Your Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Designation",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isOwner = true;
                          isStaff = false;
                        });
                        _sendDataToParent(); // Pass data to parent when designation changes
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isOwner ? Colors.blue : Colors.grey[300],
                        foregroundColor:
                            isOwner ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Owner"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isStaff = true;
                          isOwner = false;
                        });
                        _sendDataToParent(); // Pass data to parent when designation changes
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isStaff ? Colors.blue : Colors.grey[300],
                        foregroundColor:
                            isStaff ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Staff"),
                    ),
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

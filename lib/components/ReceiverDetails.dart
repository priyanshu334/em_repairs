import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:em_repairs/models/receiver_model.dart';
import 'package:em_repairs/provider/receiver_provider.dart'; // Import receiver provider

class ReceiverDetails extends StatefulWidget {
  final Function(ReceiverDetailsModel receiver) onReceiverAdded; // Callback for the entire receiver model

  const ReceiverDetails({Key? key, required this.onReceiverAdded}) : super(key: key);

  @override
  _ReceiverDetailsState createState() => _ReceiverDetailsState();
}

class _ReceiverDetailsState extends State<ReceiverDetails> {
  final TextEditingController _nameController = TextEditingController();
  bool isOwner = false;
  bool isStaff = false;

  @override
  void dispose() {
    _nameController.dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receiverDetailsProvider = Provider.of<ReceiverDetailsProvider>(context);

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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isOwner ? Colors.blue : Colors.grey[300],
                        foregroundColor: isOwner ? Colors.white : Colors.black,
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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isStaff ? Colors.blue : Colors.grey[300],
                        foregroundColor: isStaff ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Staff"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final receiver = ReceiverDetailsModel(
                      id: null, // Let Appwrite generate the ID
                      name: _nameController.text,
                      isOwner: isOwner,
                      isStaff: isStaff,
                    );

                    // Add receiver and let Appwrite generate the ID
                    await receiverDetailsProvider.addReceiver(receiver);

                    // Notify the parent widget with the entire receiver model
                    widget.onReceiverAdded(receiver);

                    if (mounted) {
                      setState(() {
                        isOwner = false;
                        isStaff = false;
                      });
                    }
                  } catch (e) {
                    debugPrint('Error adding receiver: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Save Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

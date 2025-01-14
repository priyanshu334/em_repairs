import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:em_repairs/models/receiver_model.dart';
import 'package:em_repairs/services/apwrite_service.dart';
import 'package:appwrite/appwrite.dart';

class ReceiverDetails extends StatefulWidget {
  final String? receiverId; // ID of the receiver to update (null for new records)

  const ReceiverDetails({Key? key, this.receiverId}) : super(key: key);

  @override
  _ReceiverDetailsState createState() => _ReceiverDetailsState();
}

class _ReceiverDetailsState extends State<ReceiverDetails> {
  final TextEditingController _nameController = TextEditingController();
  bool isOwner = false;
  bool isStaff = false;
  final Uuid uuid = Uuid();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.receiverId != null) {
      _fetchReceiverDetails(widget.receiverId!);
    }
  }

  Future<void> _fetchReceiverDetails(String id) async {
    try {
      setState(() => isLoading = true);

      final databases = Databases(AppwriteService().client); // Initialize Appwrite service
      final response = await databases.getDocument(
        databaseId: '678241a4000c5def62aa', // Replace with your actual database ID
        collectionId: '6782c62d003283a3990f', // Replace with your actual collection ID
        documentId: id,
      );

      final receiver = ReceiverDetailsModel.fromMap(response.data, response.$id);

      // Update the form with existing data
      _nameController.text = receiver.name;
      setState(() {
        isOwner = receiver.isOwner;
        isStaff = receiver.isStaff;
      });
    } catch (e) {
      debugPrint('Error fetching receiver details: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveReceiverDetails() async {
    try {
      setState(() => isLoading = true);

      final databases = Databases(AppwriteService().client); // Initialize Appwrite service

      if (widget.receiverId != null) {
        // Update existing record
        await databases.updateDocument(
          databaseId: '678241a4000c5def62aa', // Replace with your actual database ID
          collectionId: '6782c62d003283a3990f', // Replace with your actual collection ID
          documentId: widget.receiverId!,
          data: {
            'name': _nameController.text,
            'isOwner': isOwner,
            'isStaff': isStaff,
          },
        );
      } else {
        // Create a new record
        final newId = uuid.v4();
        await databases.createDocument(
          databaseId: '678241a4000c5def62aa', // Replace with your actual database ID
          collectionId: '6782c62d003283a3990f', // Replace with your actual collection ID
          documentId: newId,
          data: {
            'name': _nameController.text,
            'isOwner': isOwner,
            'isStaff': isStaff,
          },
        );
      }

      // Clear the form after saving
      _nameController.clear();
      setState(() {
        isOwner = false;
        isStaff = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.receiverId != null ? "Receiver updated" : "Receiver added")),
      );
    } catch (e) {
      debugPrint('Error saving receiver details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save receiver details")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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
                "Receiver Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Enter Your Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Designation",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            isOwner = true;
                            isStaff = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isOwner ? Colors.blue : Colors.grey[300],
                        foregroundColor: isOwner ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Owner"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            isStaff = true;
                            isOwner = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isStaff ? Colors.blue : Colors.grey[300],
                        foregroundColor: isStaff ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Staff"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveReceiverDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Save Details"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

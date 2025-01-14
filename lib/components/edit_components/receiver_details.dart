import 'package:em_repairs/provider/receiver_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:em_repairs/models/receiver_model.dart';


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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.receiverId != null) {
      _fetchReceiverDetails(widget.receiverId!);
    }
  }

  Future<void> _fetchReceiverDetails(String id) async {
    setState(() => isLoading = true);
    try {
      final receiverProvider = Provider.of<ReceiverDetailsProvider>(context, listen: false);
      final receiver = await receiverProvider.getReceiverById(id);
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
    setState(() => isLoading = true);
    try {
      final receiverProvider = Provider.of<ReceiverDetailsProvider>(context, listen: false);

      final receiver = ReceiverDetailsModel(
        id: widget.receiverId,  // Keep existing ID if available
        name: _nameController.text,
        isOwner: isOwner,
        isStaff: isStaff,
      );

      if (widget.receiverId != null) {
        await receiverProvider.addReceiver(receiver); // Update receiver if ID is present
      } else {
        await receiverProvider.addReceiver(receiver); // Add new receiver
      }

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

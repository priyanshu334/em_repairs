import 'package:flutter/material.dart';

class ReceiverDetails extends StatefulWidget {
  const ReceiverDetails({Key? key}) : super(key: key);

  @override
  _ReceiverDetailsState createState() => _ReceiverDetailsState();
}

class _ReceiverDetailsState extends State<ReceiverDetails> {
  final TextEditingController _nameController = TextEditingController();
  bool isOwner = false;
  bool isStaff = false;

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
            ],
          ),
        ),
      ),
    );
  }
}

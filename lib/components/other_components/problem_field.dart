import 'package:flutter/material.dart';

class ProblemField extends StatefulWidget {
  final TextEditingController ProblemController;

  const ProblemField({super.key, required this.ProblemController});

  @override
  State<ProblemField> createState() => _ProblemFieldState();
}

class _ProblemFieldState extends State<ProblemField> {
  // List to store problems
  List<String> _problems = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the list of added problems
          ..._problems.map((problem) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      problem,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _problems.remove(problem); // Remove the problem
                      });
                    },
                  ),
                ],
              ),
            );
          }).toList(),
          const Text(
            "Write Problems",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              // Expanded allows the TextField to take available space
              Expanded(
                child: TextField(
                  controller: widget.ProblemController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Describe problem',
                  ),
                ),
              ),
              const SizedBox(
                width: 12, // Add spacing between TextField and Button
              ),
              ElevatedButton(
                onPressed: () {
                  final text = widget.ProblemController.text;
                  if (text.isNotEmpty) {
                    setState(() {
                      _problems.add(text); // Add the problem to the list
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Problem Added: $text')),
                    );
                    widget.ProblemController.clear(); // Clear the TextField
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a problem')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:em_repairs/provider/lock_code_provider.dart';
import 'package:flutter/material.dart';
import 'package:em_repairs/pages/parttern_page.dart';
import 'package:em_repairs/models/lock_code_model.dart';
import 'package:provider/provider.dart';

class LockCode extends StatefulWidget {
  final Function(LockCodeModel) onGeneratedId; // Callback to send the full LockCodeModel to the parent

  const LockCode({super.key, required this.onGeneratedId});

  @override
  State<LockCode> createState() => _LockCodeState();
}

class _LockCodeState extends State<LockCode> {
  final TextEditingController _textController = TextEditingController();
  List<int> _enteredLockCode = [];
  String? _enteredPatternCode;

  void _showLockCodeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Lock Code"),
          content: TextField(
            controller: _textController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter lock code (e.g., 1234)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final text = _textController.text;
                if (text.isNotEmpty && text.length > 1) {
                  setState(() {
                    _enteredLockCode =
                        text.split('').map(int.parse).toList();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lock Code Entered: $_enteredLockCode')),
                  );
                  _textController.clear();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid lock code')),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToPatternLockPage() async {
    // Create the lock code model
    LockCodeModel newLockCode = LockCodeModel(
      id: '', // Leave ID blank, Appwrite will generate it
      lockCode: _enteredLockCode,
      patternCode: _enteredPatternCode,
    );

    // Add the lock code to the provider
    await context.read<LockCodeProvider>().addLockCode(newLockCode);

    // Get the saved lock code (the one with the generated ID)
    final LockCodeModel savedLockCode = context.read<LockCodeProvider>().lockCodes.last;

    // Send the saved lock code model to the parent
    widget.onGeneratedId(savedLockCode);

    // Navigate to the PatternLockPage
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatternLockPage(
          onSubmit: (String patternCode) {
            setState(() {
              _enteredPatternCode = patternCode;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pattern Code Entered: $patternCode')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lock Code",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showLockCodeDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade600,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              icon: const Icon(
                Icons.lock,
                color: Colors.white,
                size: 24,
              ),
              label: const Text(
                "Set Lock Code",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _navigateToPatternLockPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade600,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              icon: const Icon(
                Icons.pattern,
                color: Colors.white,
                size: 24,
              ),
              label: const Text(
                "Set Pattern Lock Code",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_enteredLockCode.isNotEmpty)
            Text(
              'Entered Lock Code: ${_enteredLockCode.join(', ')}',
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
          const SizedBox(height: 20),
          if (_enteredPatternCode != null)
            Text(
              'Entered Pattern Code: $_enteredPatternCode',
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),
        ],
      ),
    );
  }
}

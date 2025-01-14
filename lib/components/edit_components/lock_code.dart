import 'package:flutter/material.dart';
import 'package:em_repairs/pages/parttern_page.dart';
import 'package:uuid/uuid.dart';

class LockCode extends StatefulWidget {
  final Function(String) onGeneratedId;

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
    String uuid = Uuid().v4();
    widget.onGeneratedId(uuid);

    // LockCodeModel creation without using Provider
    final newLockCode = {
      'id': uuid,
      'lockCode': _enteredLockCode,
      'patternCode': _enteredPatternCode,
    };

    // Simulating saving lock code, without using provider
    // You can store it in a local state or any storage as per your need.

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

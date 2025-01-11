import 'package:em_repairs/pages/parttern_page.dart';
import 'package:flutter/material.dart';

class LockCodeComponent extends StatefulWidget {
  final Function(List<int> lockCode) onLockCodeSet;
  final Function(List<int> patternCode) onPatternCodeSet;

  const LockCodeComponent({
    Key? key,
    required this.onLockCodeSet,
    required this.onPatternCodeSet,
  }) : super(key: key);

  @override
  State<LockCodeComponent> createState() => _LockCodeComponentState();
}

class _LockCodeComponentState extends State<LockCodeComponent> {
  final TextEditingController _textController = TextEditingController();

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
                Navigator.pop(context); // Close dialog without saving
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final text = _textController.text;
                if (text.isNotEmpty && text.length > 1) {
                  List<int> lockCode = text.split('').map(int.parse).toList();

                  // Pass lock code to the parent
                  widget.onLockCodeSet(lockCode);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lock Code Set: $lockCode')),
                  );

                  _textController.clear();
                  Navigator.pop(context); // Close dialog after saving
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid lock code'),
                    ),
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

  void _navigateToPatternLockPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatternLockPage(
          onSubmit: (patternCode) {
            // Pass pattern code to the parent
            widget.onPatternCodeSet(patternCode);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pattern Code Set: $patternCode')),
            );

            Navigator.pop(context); // Return to the previous screen
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
          ElevatedButton(
            onPressed: _showLockCodeDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade600,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Set Lock Code",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _navigateToPatternLockPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Set Pattern Lock Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.pattern,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

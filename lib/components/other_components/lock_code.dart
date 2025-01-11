import 'package:em_repairs/pages/parttern_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockCode extends StatefulWidget {
  const LockCode({super.key});

  @override
  State<LockCode> createState() => _LockCodeState();
}

class _LockCodeState extends State<LockCode> {
  final TextEditingController _textController = TextEditingController();
  List<int> _storedLockCode = [];
  String? _storedPatternCode;

  @override
  void initState() {
    super.initState();
    _loadLockCode(); // Load saved lock code on start
    _loadPatternCode(); // Load saved pattern code on start
  }

  // Load stored lock code from shared preferences
  Future<void> _loadLockCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedLockCode =
          prefs.getStringList('lock_code')?.map(int.parse).toList() ?? [];
    });
  }

  // Load stored pattern code from shared preferences
  Future<void> _loadPatternCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedPatternCode = prefs.getString('pattern_code');
    });
  }

  // Store the lock code in shared preferences
  Future<void> _saveLockCode(List<int> code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'lock_code', code.map((e) => e.toString()).toList());

    setState(() {
      _storedLockCode = code;
    });
  }

  // Store the pattern code in shared preferences
  Future<void> _savePatternCode(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pattern_code', code);
    setState(() {
      _storedPatternCode = code;
    });
  }

  // Function to show dialog box for entering lock code
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
                  _saveLockCode(
                      lockCode); // Save lock code to SharedPreferences
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lock Code Stored: $lockCode')),
                  );
                  _textController.clear();
                  Navigator.pop(context); // Close dialog after saving
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

  // Navigate to the PatternLockPage
  void _navigateToPatternLockPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PatternLockPage(),
      ),
    );
    if (result != null && result is String) {
      _savePatternCode(result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pattern Code Stored: $result')),
      );
    }
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
            onPressed: _showLockCodeDialog, // Open dialog to set lock code
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade600, // Slightly darker pink
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Less rounded
              ),
              elevation: 5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Set Lock Code",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _navigateToPatternLockPage, // Navigate to pattern lock page
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600, // Slightly darker blue
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Less rounded
              ),
              elevation: 5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Set Pattern Lock Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.pattern, // Use a pattern-related icon
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_storedLockCode.isNotEmpty)
            Text(
              'Stored Lock Code: ${_storedLockCode.join(', ')}',
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
          const SizedBox(height: 20),
          if (_storedPatternCode != null)
            Text(
              'Stored Pattern Code: $_storedPatternCode',
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PatternLockPage extends StatefulWidget {
  final void Function(List<int> patternCode) onSubmit;

  const PatternLockPage({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<PatternLockPage> createState() => _PatternLockPageState();
}

class _PatternLockPageState extends State<PatternLockPage> {
  List<int> _pattern = []; // Stores the selected pattern indices
  bool _isPatternValid = true; // Validation flag for pattern input

  // Adds a point to the pattern if not already selected
  void _addToPattern(int index) {
    if (!_pattern.contains(index)) {
      setState(() {
        _pattern.add(index);
      });
    }
  }

  // Clears the pattern input
  void _resetPattern() {
    setState(() {
      _pattern.clear();
    });
  }

  // Validates and submits the pattern
  void _submitPatternLockCode() {
    if (_pattern.length < 4) {
      setState(() {
        _isPatternValid = false;
      });
      return;
    }
    setState(() {
      _isPatternValid = true;
    });

    // Passes the pattern to the parent widget via the callback
    widget.onSubmit(_pattern);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pattern Code Set: ${_pattern.join(',')}')),
    );

    Navigator.pop(context); // Navigates back after submission
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Pattern Lock Code'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Current Pattern Display
            if (_pattern.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity,
                child: Text(
                  'Current Pattern: ${_pattern.join(' -> ')}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),
            // Grid for Pattern Selection
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _addToPattern(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _pattern.contains(index)
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 70,
                    width: 70,
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: _pattern.contains(index)
                              ? Colors.white
                              : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Reset Button
            ElevatedButton(
              onPressed: _resetPattern,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Reset Pattern'),
            ),
            const SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: _submitPatternLockCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Submit Pattern'),
            ),
            const SizedBox(height: 20),
            // Validation Message
            if (!_isPatternValid)
              const Text(
                'Pattern must have at least 4 points!',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

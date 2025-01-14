import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class PatternLockPage extends StatefulWidget {
  final Function(String) onSubmit; // Callback to send the lock code to the parent

  const PatternLockPage({super.key, required this.onSubmit});

  @override
  State<PatternLockPage> createState() => _PatternLockPageState();
}

class _PatternLockPageState extends State<PatternLockPage> {
  List<int> _pattern = []; // To store the pattern entered by the user
  bool _isPatternValid = true; // To handle invalid pattern scenarios

  // Function to handle the user's pattern input
  void _addToPattern(int index) {
    if (!_pattern.contains(index)) {
      setState(() {
        _pattern.add(index);
      });
    }
  }

  // Function to reset the pattern
  void _resetPattern() {
    setState(() {
      _pattern.clear();
    });
  }

  // Function to save the pattern lock code and pass it to the parent
  void _submitPattern() {
    if (_pattern.isEmpty) {
      setState(() {
        _isPatternValid = false;
      });
      return;
    }
    String patternCode = _pattern.join(','); // Convert pattern to a string
    widget.onSubmit(patternCode); // Pass the pattern to the parent
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pattern submitted: $patternCode')),
    );
    _resetPattern(); // Optionally reset the pattern after submission
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Pattern Lock',
        leadingIcon: Icons.lock,
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the current pattern lock code
              AnimatedOpacity(
                opacity: _pattern.isEmpty ? 0 : 1,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,
                  child: Text(
                    'Current Pattern Code: ${_pattern.join(' -> ')}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Grid layout for the pattern lock
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: GridView.builder(
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
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: _pattern.contains(index)
                              ? Colors.blueAccent
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            if (_pattern.contains(index))
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.4),
                                spreadRadius: 3,
                                blurRadius: 5,
                              ),
                          ],
                        ),
                        height: 70, // Larger size for the boxes
                        width: 70,  // Larger size for the boxes
                        child: Center(
                          child: AnimatedOpacity(
                            opacity: _pattern.contains(index) ? 1 : 0.4,
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Reset button
              AnimatedOpacity(
                opacity: _pattern.isEmpty ? 0 : 1,
                duration: const Duration(milliseconds: 500),
                child: ElevatedButton(
                  onPressed: _resetPattern,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'Reset Pattern',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Submit button
              ElevatedButton(
                onPressed: _submitPattern,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
                child: const Text(
                  'Submit Pattern',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              // Feedback message (validation)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isPatternValid
                    ? Container()
                    : const Text(
                        "Invalid Pattern! Please create a pattern before submitting.",
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

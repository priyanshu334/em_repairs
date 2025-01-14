import 'package:flutter/material.dart';

class FilterToggle extends StatelessWidget {
  final bool showFilters;
  final VoidCallback onToggle;

  const FilterToggle({
    Key? key,
    required this.showFilters,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: showFilters ? Colors.blue : Colors.black,
        ),
        child: Row(
          children: const [
            Icon(Icons.search),
            SizedBox(width: 5),
            Text('Filters'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TodaySearchButtonWidget extends StatelessWidget {
  final VoidCallback? onTodayPressed;
  final VoidCallback? onSearchPressed;

  const TodaySearchButtonWidget({
    Key? key,
    this.onTodayPressed,
    this.onSearchPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: onTodayPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade600,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Today",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: onSearchPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Search",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

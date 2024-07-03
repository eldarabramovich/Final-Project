import 'package:flutter/material.dart';



class AssignmentDetailRow extends StatelessWidget {
  const AssignmentDetailRow(
      {super.key, required this.title, required this.statusValue});

  final String title;
  final String statusValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          statusValue,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 43, 42, 42),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFFA5A5A5),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

class AssignmentButton extends StatelessWidget {
  const AssignmentButton(
      {super.key, required this.title, required this.onPress});

  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        height: 40.0,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6789CA), Color(0xFF345FB4)],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.5, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
            borderRadius: BorderRadius.circular(20.0)),
        child: Center(
            child: Text(
          title,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: Color.fromARGB(255, 255, 255, 255)),
        )),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/DataJustForExample/AssignmentData.dart';

class StudentAssignment extends StatelessWidget {
  const StudentAssignment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("מטלות"),
          backgroundColor: Colors.blue.shade800,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF4F6F7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: ListView.builder(
                    padding: EdgeInsets.all(20.0),
                    //we will count also how many assignemt we have to add using th lenght
                    itemCount: assignment.length,
                    itemBuilder: (context, int Index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Color(0xFFF4F6F7),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFA5A5A5),
                                        blurRadius: 2.0,
                                      )
                                    ]),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 30.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF6789CA)
                                              .withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        //here we will shows the data of the assignmrnt detalis
                                        child: Center(
                                          child: Text(
                                            assignment[Index].subjectName,
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF345FB4),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0 / 2,
                                      ),
                                      Text(
                                        assignment[Index].description,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0 / 2,
                                      ),
                                      AssignmentDetailRow(
                                        statusValue: assignment[Index].lastData,
                                        title: 'מועד אחרון להגשת המטלה:',
                                      ),
                                      SizedBox(
                                        height: 30.0 / 2,
                                      ),
                                      AssignmentButton(
                                        onPress: () {
                                          //here we can open a new screen for more information ir upload a file
                                        },
                                        title: 'הגשת העבודה',
                                      )
                                    ]),
                              ),
                            ]),
                      );
                    }),
              ),
            ),
          ],
        ));
  }
}

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
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 43, 42, 42),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFFA5A5A5),
          ),
        ),
      ],
    );
  }
}

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

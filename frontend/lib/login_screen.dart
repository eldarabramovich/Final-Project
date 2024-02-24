// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

//import 'dart:js_util';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/Admin/AdminHomeScreen.dart';

late bool _passwordVisible;

class LoginScreen extends StatefulWidget {
  static String routeName = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = true;
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      //when the user tap at the screen at place that not at input text the keyboart disapper
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/imgs/logo.jpg',
                  height: 150.0,
                  width: 150.0,
                ),
                SizedBox(
                  height: 20.0 / 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Welcome',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
                SizedBox(
                  height: 20.0 / 6,
                ),
                Text('ברוכים הבאים')
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0 * 3),
                topRight: Radius.circular(20 * 3),
              ),
              color: Color.fromARGB(255, 207, 229, 243),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            labelText: 'שם משתמש',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isDense: true,
                            labelStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              height: 0.5,
                            ),
                            //hintStyle
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              height: 0.5,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black26, width: 0.7),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black26, width: 0.7),
                            ),

                            //when the user enter a wrong information the color change
                            errorBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.2),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          obscureText: _passwordVisible,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            labelText: 'סיסמה',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isDense: true,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              iconSize: 20.0,
                            ),
                            labelStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              height: 0.5,
                            ),
                            //hintStyle
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              height: 0.5,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black26, width: 0.7),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black26, width: 0.7),
                            ),

                            //when the user enter a wrong information the color change
                            errorBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.2),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        DefaultButton(
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  AdminHomeScreen.routeName, (route) => false);
                            }
                          },
                          title: 'כניסה',
                          iconData: Icons.arrow_forward_ios_outlined,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

class DefaultButton extends StatelessWidget {
  final VoidCallback onPress;
  final String title;
  final IconData iconData;

  const DefaultButton(
      {super.key,
      required this.onPress,
      required this.title,
      required this.iconData});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
        ),
        padding: EdgeInsets.only(right: 20.0),
        width: double.infinity,
        height: 60.0,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6789CA), Color(0xFF345FB4)],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.5, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
            borderRadius: BorderRadius.circular(20.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'כניסה',
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_outlined,
              size: 30.0,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

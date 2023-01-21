import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_app_3/common_widgets/custom_raised_button.dart';

class SignInButton  extends CustomRaisedButton
{
  SignInButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) : super(
    child: Text(
      text,style:TextStyle(color: textColor,fontSize:15.0),
    ),
    color: color,
    height: 40.0,
    borderRadius: 4.0,
    onPressed: onPressed,
  );
}
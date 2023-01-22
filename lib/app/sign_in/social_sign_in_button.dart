import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_app_3/common_widgets/custom_raised_button.dart';

class SocialSignInButton  extends CustomRaisedButton
{
  SocialSignInButton({
    required String assestName,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) : super(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset(assestName),
        Text(text,
        style:  TextStyle(color: textColor,fontSize: 15.0),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(assestName),),
      ],
    ),
    color: color,
    height: 40.0,
    borderRadius: 4.0,
    onPressed: onPressed,
  );
}
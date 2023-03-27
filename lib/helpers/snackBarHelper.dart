import 'package:flutter/material.dart';


class SnackBarHelper{
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackBar(String message,BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
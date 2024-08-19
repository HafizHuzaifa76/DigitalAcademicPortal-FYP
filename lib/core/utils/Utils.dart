import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils{

  void toastErrorMessage(String message, BuildContext context){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white, fontSize: 16.0,
    );
  }
  void toast(String message, BuildContext context){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Color(0xFF145849).withOpacity(0.6),
      textColor: Colors.white, fontSize: 16.0,
    );
  }

  void showMessageBar(BuildContext context, String message){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey.shade900,
      textColor: Colors.white, fontSize: 16.0,
    );
  }
}
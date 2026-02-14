import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

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

  showErrorSnackBar(String main, String message){
    Get.snackbar(
        main,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        icon: const Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
    );
  }

  showSuccessSnackBar(String main, String message){
    Get.snackbar(
        main,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        colorText: Colors.white,
        icon: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white)
    );
  }

  String toRomanNumeral(int number) {
    if (number < 1 || number > 20) return ""; // Limit the range from 1 to 20
    List<String> romanNumerals = ['X', 'IX', 'V', 'IV', 'I'];
    List<int> values = [10, 9, 5, 4, 1];

    String result = "";
    for (int i = 0; i < values.length; i++) {
      while (number >= values[i]) {
        number -= values[i];
        result += romanNumerals[i];
      }
    }
    return result;
  }

}
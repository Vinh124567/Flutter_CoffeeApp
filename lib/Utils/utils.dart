import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils{
  static toastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
    backgroundColor: Colors.green,
      textColor: Colors.white
    );
  }

  static void flushBarErrorMessage(String message,BuildContext context){
    showFlushbar(context: context,
        flushbar: Flushbar(
        message:message,
        backgroundColor: Colors.red,
          title:"ERROR",
          messageColor: Colors.black,
          duration: Duration(seconds: 2),
    )..show(context),
    );
  }


}
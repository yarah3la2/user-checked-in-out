import 'package:Task/utilies/constants.dart';
import 'package:flutter/material.dart';

import '../HomeScreen.dart';

class SingleActionAlert {
  final UserMode mode;
  final String message;
  final BuildContext context;

  SingleActionAlert(
      {this.message,
      @required
          this.context,
      @required
          this.mode}); //: assert(buttonAction == null || noOfPop == null);

  Future<void> showAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: alertView,
    );
  }

  Widget alertView(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      title: Icon(
        Icons.check_circle,
        size: 60,
        color: (mode == UserMode.SIGNEDIN) ? Colors.green : Colors.red,
      ),
      content: alertContent(context),
      contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 5),
    );
  }

  SingleChildScrollView alertContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          alertMessage(),
          SizedBox(height: 20),
          alertActions(context),
        ],
      ),
    );
  }

  Text alertMessage() {
    return Text(
      message ?? "",
      textAlign: TextAlign.center,
      style: normalTextStyle,
    );
  }

  Widget alertActions(BuildContext context) {
    return FlatButton(
      child: Text(
        "ok",
        style: alertButtonTextStyle,
      ),
      onPressed: () => handleButtonAction(),
    );
  }

  handleButtonAction() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

ShowAlertMessage(String message, BuildContext context, UserMode mode) {
  return SingleActionAlert(message: message, mode: mode, context: context)
      .showAlert();
}

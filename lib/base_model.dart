import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  bool _busy = false;
  bool get busy => _busy;

  setBusy(val) {
    _busy = val;
    notifyListeners();
    if (val == true) {
      return CircularProgressIndicator();
    }
  }

  showDialogue({BuildContext context, message, Function onTap}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Success"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('$message'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  onTap() == null ? Navigator.of(context).pop() : onTap();
                },
              ),
            ],
          );
        });
  }

   showErrorDialogue({BuildContext context, message, Function onTap}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Am error occured"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('$message'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  onTap() == null ? Navigator.of(context).pop() : onTap();
                },
              ),
            ],
          );
        });
  }
}

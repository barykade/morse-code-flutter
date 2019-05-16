// Flutter code sample for material.IconButton.2

// In this sample the icon button's background color is defined with an [Ink]
// widget whose child is an [IconButton]. The icon button's filled background
// is a light shade of blue, it's a filled circle, and it's as big as the
// button is.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: MyStatelessWidget(),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class MyStatelessWidget extends StatelessWidget {
  MyStatelessWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Ink(
          decoration: ShapeDecoration(
            color: Colors.red,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(Icons.android),
            color: Colors.white,
            onPressed: () {
              print("filled background");
            },
          ),
        ),
      ),
    );
  }
}

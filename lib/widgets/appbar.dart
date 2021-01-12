import 'package:flutter/material.dart';

Widget MyAppBar({@required String title, List<Widget> actions}) {
  return AppBar(
    //TODO: MAKE BEAUTIFUL
    centerTitle: true,
    actions: actions,
    title: Text(
      title,
      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
    ),
    // backgroundColor: Colors.blue,
    elevation: 1.0,
    // shadowColor: Colors.transparent,
  );
}

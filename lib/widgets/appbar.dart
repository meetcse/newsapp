import 'package:flutter/material.dart';

class AppBarWidget {
  static Widget myAppBar(BuildContext context,
      {@required String title, List<Widget> actions}) {
    return AppBar(
      centerTitle: true,
      actions: actions,

      title: Text(
        title,
        style: Theme.of(context).textTheme.headline3,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0.0,
      // shadowColor: Colors.transparent,
    );
  }
}

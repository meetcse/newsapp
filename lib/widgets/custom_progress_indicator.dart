import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitWanderingCubes(
      color: Theme.of(context).primaryColor,
      size: 60,
    );
  }
}

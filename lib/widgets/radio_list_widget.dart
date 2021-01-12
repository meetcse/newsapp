import 'package:flutter/material.dart';

class RadioListWidget extends StatefulWidget {
  List<Map<String, dynamic>> list;
  String groupValue;
  Function(String) onChanged;

  RadioListWidget(
      {@required this.list, @required this.groupValue, this.onChanged});
  @override
  _RadioListWidgetState createState() => _RadioListWidgetState();
}

class _RadioListWidgetState extends State<RadioListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.list.length,
          itemBuilder: (context, index) {
            return RadioListTile(
                value: widget.list[index]['id'],
                title: Text(widget.list[index]['value']),
                groupValue: widget.groupValue,
                onChanged: (value) {
                  widget.groupValue = widget.list[index]['id'];
                  setState(() {});
                  return widget.onChanged(value);
                });
          }),
    );
  }
}

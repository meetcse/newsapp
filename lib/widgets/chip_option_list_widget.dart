import 'package:flutter/material.dart';

class ChipOptionListWidget extends StatefulWidget {
  List<Map<String, dynamic>> list;
  String groupValue;
  Function(String) onChanged;

  ChipOptionListWidget(
      {@required this.list, @required this.groupValue, this.onChanged});
  @override
  _ChipOptionListWidget createState() => _ChipOptionListWidget();
}

class _ChipOptionListWidget extends State<ChipOptionListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Wrap(
      spacing: 0.0, // gap between adjacent chips
      runSpacing: 1.0, // gap between lines
      children: List<Widget>.generate(widget.list.length, (int index) {
        return _createChipLayout(index, context);
      }),
    ));
  }

  _createChipLayout(index, context) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 4),
      child: Stack(children: [
        GestureDetector(
          onTap: () {
            // onChipTap(index);
            widget.groupValue = widget.list[index]['id'];
            setState(() {});
            return widget.onChanged(widget.list[index]['id']);
          },
          child: Chip(
            labelPadding: EdgeInsets.only(
              left: 8,
              right: 8,
              top: 0,
              bottom: 0,
            ),
            label: Text(
              widget.list[index]['value'],
              style: widget.groupValue == widget.list[index]['id']
                  ? Theme.of(context).textTheme.bodyText2
                  : Theme.of(context).textTheme.bodyText1,
            ),
            backgroundColor: widget.groupValue == widget.list[index]['id']
                ? Theme.of(context).primaryColor
                : Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color.fromARGB(255, 187, 187, 187),
                width: 0.5,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            labelStyle: Theme.of(context).textTheme.button.copyWith(),
            padding: const EdgeInsets.all(0),
          ),
        ),
      ]),
    );
  }
}

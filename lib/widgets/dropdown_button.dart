import 'package:flutter/material.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/icon_helper.dart';

class DropdownButtonWidget extends StatefulWidget {
  DropdownButtonWidget({Key? key, required this.list, required this.dropdownValue, this.getData, required this.onChanged}) : super(key: key);

  final List<String> list;
  late String dropdownValue;
  final Function? getData;
  final void Function(String? value) onChanged;

  @override
  State<DropdownButtonWidget> createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {


  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.dropdownValue,
      icon: Icon(IconHelper.dropdownExpand),
      elevation: 6,
      style: TextStyle(color: ColorHelper.textColorBlue),
      underline: Container(
        height: 2,
        color: ColorHelper.dropdownUnderline,
      ),
      onChanged: widget.onChanged,
      items: widget.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

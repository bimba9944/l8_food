import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/language_helper.dart';

class DeleteDialogWidget extends StatefulWidget {
  final Function(String oldValue) onPressed;
  final String oldValue;

  const DeleteDialogWidget({required this.onPressed, required this.oldValue});

  @override
  State<DeleteDialogWidget> createState() => _DeleteDialogWidgetState();
}

class _DeleteDialogWidgetState extends State<DeleteDialogWidget> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: Text(AppLocale.deleteMealQuestion.getString(context))),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => widget.onPressed(widget.oldValue),
              style: ElevatedButton.styleFrom(primary: ColorHelper.deleteMealButtonYes),
              child: Text(AppLocale.yes.getString(context), style: TextStyle(color: ColorHelper.textColorWhite)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(primary: ColorHelper.deleteMealButtonNo),
              child: Text(AppLocale.no.getString(context), style: TextStyle(color: ColorHelper.textColorWhite)),
            ),
          ],
        )
      ],
    );
  }
}

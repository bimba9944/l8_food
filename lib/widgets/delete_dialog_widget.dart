import 'package:flutter/material.dart';
import 'package:l8_food/helpers/color_helper.dart';

class DeleteDialogWidget extends StatefulWidget {
  final Function(String oldValue) onPressed;
  final String oldValue;

  const DeleteDialogWidget({required this.onPressed, required this.oldValue});

  @override
  State<DeleteDialogWidget> createState() => _DeleteDialogWidgetState();
}

class _DeleteDialogWidgetState extends State<DeleteDialogWidget> {
  void _delete(){
    widget.onPressed(widget.oldValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Center(child: Text('Da li sigurno zelite da izbrisete ovo jelo?')),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => _delete(),
              style: ElevatedButton.styleFrom(primary: ColorHelper.deleteMealButtonYes),
              child: Text('Yes', style: TextStyle(color: ColorHelper.textColorWhite)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(primary: ColorHelper.deleteMealButtonNo),
              child: Text('No', style: TextStyle(color: ColorHelper.textColorWhite)),
            ),
          ],
        )
      ],
    );
  }
}

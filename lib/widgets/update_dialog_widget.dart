import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/language_helper.dart';

class UpdateDialogWidget extends StatefulWidget {
  const UpdateDialogWidget({super.key, required this.onPressed, required this.controller, required this.oldValue});

  final Function(String controler, String oldValue) onPressed;
  final TextEditingController controller;
  final String oldValue;

  @override
  State<UpdateDialogWidget> createState() => _UpdateDialogWidgetState();
}

class _UpdateDialogWidgetState extends State<UpdateDialogWidget> {
  @override
  void initState() {
    widget.controller.text = widget.oldValue;
    super.initState();
  }
  Widget _buildSingleInputField(String hintTxt, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: ColorHelper.listTileBorder)),
        hintText: hintTxt,
      ),
    );
  }

  void _update() {
    widget.onPressed(widget.controller.text, widget.oldValue);
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSingleInputField(AppLocale.changeMealDialog.getString(context), widget.controller),
            const SizedBox(height: 10),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => _update(),
              style: ElevatedButton.styleFrom(primary: ColorHelper.updateMealUpdate),
              child: Text(AppLocale.updateButton.getString(context), style: TextStyle(color: ColorHelper.textColorWhite)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(primary: ColorHelper.updateMealCancel),
              child: Text(AppLocale.cancelButton.getString(context), style: TextStyle(color: ColorHelper.textColorWhite)),
            ),
          ],
        )
      ],
    );
  }
}

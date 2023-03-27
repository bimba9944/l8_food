import 'package:flutter/material.dart';
import 'package:l8_food/helpers/color_helper.dart';

class UpdateDialogWidget extends StatefulWidget {
  const UpdateDialogWidget({super.key, required this.onPressed, required this.controller, required this.oldValue});

  final Function(String controler, String oldValue) onPressed;
  final TextEditingController controller;
  final String oldValue;

  @override
  State<UpdateDialogWidget> createState() => _UpdateDialogWidgetState();
}

class _UpdateDialogWidgetState extends State<UpdateDialogWidget> {
  Widget _buildSingleInputField(String hintTxt, TextEditingController controler) {
    return TextFormField(
      controller: controler,
      decoration: InputDecoration(
        border:  OutlineInputBorder(borderSide: BorderSide(color: ColorHelper.listTileBorder)),
        hintText: hintTxt,
      ),
    );
  }

  void _update(){
    widget.onPressed(widget.controller.text, widget.oldValue);
  }

  @override
  void initState() {
    widget.controller.text = widget.oldValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSingleInputField('Promenite jelo', widget.controller),
            const SizedBox(
              height: 10,
            ),
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
              child: Text('Update', style: TextStyle(color: ColorHelper.textColorWhite)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(primary: ColorHelper.updateMealCancel),
              child: Text('Cancel', style: TextStyle(color: ColorHelper.textColorWhite)),
            ),
          ],
        )
      ],
    );
  }
}

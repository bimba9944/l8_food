import 'package:flutter/material.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/image_helper.dart';

class AppBarWidget extends StatelessWidget {
  AppBarWidget(this.iconButton, {Key? key}) : super(key: key);
  IconButton? iconButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Image.asset(
        ImageHelper.appbarImage,
        color: ColorHelper.l8ImageColorWhite,
        alignment: Alignment.center,
      ),
      leading: iconButton,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/image_helper.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key, this.iconButton,this.tabBar}) : super(key: key);
  final IconButton? iconButton;
  final TabBar? tabBar;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        ImageHelper.appbarImage,
        color: ColorHelper.l8ImageColorWhite,
        alignment: Alignment.center,
        height: 50,
      ),
      leading: iconButton,
      bottom: tabBar,
    );
  }
}

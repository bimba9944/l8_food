import 'package:flutter/material.dart';
import 'package:l8_food/widgets/appbar_widget.dart';
import 'package:l8_food/widgets/user_drawer_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: AppBarWidget(null)),
        endDrawer: const UserDrawerWidget(),
      ),
    );
  }
}

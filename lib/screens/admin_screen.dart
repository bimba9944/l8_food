import 'package:flutter/material.dart';
import 'package:l8_food/widgets/admin_drawer_widget.dart';
import 'package:l8_food/widgets/appbar_widget.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        appBar: PreferredSize(preferredSize: Size.fromHeight(60), child: AppBarWidget()),
        endDrawer: AdminDrawerWidget(),
      ),
    );
  }
}

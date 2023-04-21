import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:l8_food/helpers/app_routes.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/google_signin.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:l8_food/helpers/language_helper.dart';
import 'package:provider/provider.dart';

class AdminDrawerWidget extends StatefulWidget {
  const AdminDrawerWidget({Key? key}) : super(key: key);

  @override
  State<AdminDrawerWidget> createState() => _AdminDrawerWidgetState();
}

class _AdminDrawerWidgetState extends State<AdminDrawerWidget> {
  final _user = FirebaseAuth.instance.currentUser!;
  bool? _data;
  List<Widget> _drawerBody = [];

  void _navigateToNewPage(route) {
    Navigator.pushNamed(context, route);
  }

  void _logout() {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.logout();
  }

  DrawerHeader _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ColorHelper.drawerHeaderDark, ColorHelper.drawerHeaderLight],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(_user.photoURL!),
            radius: 40,
          ),
          Text(
            '${AppLocale.emailDrawerHeader.getString(context)}: ${_user.email}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ColorHelper.textColorWhite),
          ),
        ],
      ),
    );
  }

  void _checkIsUserAdmin(){
    //TODO then izbaci i koristi servis za firebase metodu
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final ref = db.collection('users').doc(_user.uid);
    ref.get().then((DocumentSnapshot doc) {
      _data = doc['admin'] as bool;
      if (mounted) {
        setState(() {});
      }
    });
  }

  List<Widget> _buildDrawerBody() {
    _checkIsUserAdmin();
    if (_data == true) {
      _drawerBody = _buildUserDrawer();
    } else if (_data == false) {
      _drawerBody = _buildAdminDrawerBody();
    }
    return _drawerBody;
  }

  List<Widget> _buildAdminDrawerBody() {
    return [
      ListTile(
        leading: Icon(IconHelper.historyOfOrders),
        title:  Text(AppLocale.drawerHistoryOfOrders.getString(context)),
        onTap: () => _navigateToNewPage(AppRoutes.historyOfOrders),
      ),
      const Divider(
        thickness: 1,
      ),
      ListTile(
        leading: Icon(IconHelper.listAllOrders),
        onTap: () => _navigateToNewPage(AppRoutes.historyOfAllOrders),
        title:  Text(AppLocale.drawerAllOrders.getString(context)),
      ),
      const Divider(
        thickness: 1,
      ),
      ListTile(
        leading: Icon(IconHelper.addMeal),
        onTap: () => _navigateToNewPage(AppRoutes.addFood),
        title:  Text(AppLocale.drawerAddFood.getString(context)),
      ),
      const Divider(
        thickness: 1,
      ),
      ListTile(
        leading: Icon(IconHelper.updateMeal),
        onTap: () => _navigateToNewPage(AppRoutes.updateFood),
        title:  Text(AppLocale.drawerUpdateFood.getString(context)),
      ),
      const Divider(
        thickness: 1,
      ),
      ListTile(
        leading: Icon(IconHelper.logout),
        title:  Text(AppLocale.logout.getString(context)),
        onTap: () => _logout(),
      ),
    ];
  }

  List<Widget> _buildUserDrawer() {
    return [
      ListTile(
        leading: Icon(IconHelper.historyOfOrders),
        title: Text(AppLocale.drawerHistoryOfOrders.getString(context)),
        onTap: () => _navigateToNewPage(AppRoutes.historyOfOrders),
      ),
      const Divider(
        thickness: 1,
      ),
      ListTile(
        leading: Icon(IconHelper.logout),
        title:  Text(AppLocale.logout.getString(context)),
        onTap: () => _logout(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _buildDrawerHeader(),
          ..._buildDrawerBody(),
        ],
      ),
    );
  }
}

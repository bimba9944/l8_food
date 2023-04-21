import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/google_signin.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:provider/provider.dart';

class AdminDrawerWidget extends StatefulWidget {
  const AdminDrawerWidget({Key? key}) : super(key: key);

  @override
  State<AdminDrawerWidget> createState() => _AdminDrawerWidgetState();
}

class _AdminDrawerWidgetState extends State<AdminDrawerWidget> {
  final user = FirebaseAuth.instance.currentUser!;
  bool? data;
  List<Widget> drawerBody = [];

  void _navigateToNewPage(String route) {
    Navigator.pushNamed(context, route);
  }

  void _logout() {
    final provider = Provider.of<GoogleSigninProvider>(context, listen: false);
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
            backgroundImage: NetworkImage(user.photoURL!),
            radius: 40,
          ),
          Text(
            'Email: ${user.email}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ColorHelper.textColorWhite),
          ),
        ],
      ),
    );
  }

  void _checkIsUserAdmin(){
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final ref = db.collection('users').doc(user.uid);
    ref.get().then((DocumentSnapshot doc) {
      data = doc['admin'] as bool;
      if (mounted) {
        setState(() {});
      }
    });
  }

  List<Widget> _buildDrawerBody() {
    _checkIsUserAdmin();
    if (data == true) {
      drawerBody = _buildUserDrawer();
    } else if (data == false) {
      drawerBody = _buildAdminDrawerBody();
    }
    return drawerBody;
  }

  List<Widget> _buildAdminDrawerBody() {
    return [
      ListTile(
        leading: Icon(IconHelper.historyOfOrders),
        title: const Text('Istorija porudzbina'),
        onTap: () => _navigateToNewPage('/HistoryOfOrdersScreen'),
      ),
      const Divider(
        thickness: 1,
      ),
      ListTile(
        leading: Icon(IconHelper.listAllOrders),
        onTap: () => _navigateToNewPage('/HistoryOfAllOrdersScreen'),
        title: const Text('Predgled svih porudzbina'),
      ),
      const Divider(
        thickness: 1,
      ),
      ListTile(
        leading: Icon(IconHelper.addMeal),
        onTap: () => _navigateToNewPage('/AddFoodScreen'),
        title: const Text('Dodavanje u jelovnik'),
      ),
      const Divider(
        thickness: 1,
      ),
      ListTile(
        leading: Icon(IconHelper.updateMeal),
        onTap: () => _navigateToNewPage('/UpdateFoodScreen'),
        title: const Text('Izmena jelovnika'),
      ),
      const Divider(
        thickness: 1,
      ),
      ListTile(
        leading: Icon(IconHelper.logout),
        title: const Text('Logout'),
        onTap: () => _logout(),
      ),
    ];
  }

  List<Widget> _buildUserDrawer() {
    return [
      ListTile(
        leading: Icon(IconHelper.historyOfOrders),
        title: const Text('Istorija porudzbina'),
        onTap: () => _navigateToNewPage('/HistoryOfOrdersScreen'),
      ),
      const Divider(
        thickness: 1,
      ),
      ListTile(
        leading: Icon(IconHelper.logout),
        title: const Text('Logout'),
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

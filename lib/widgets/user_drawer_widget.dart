import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:l8_food/helpers/google_signin.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:provider/provider.dart';

import 'package:l8_food/helpers/color_helper.dart';

class UserDrawerWidget extends StatefulWidget {
  const UserDrawerWidget({Key? key}) : super(key: key);

  @override
  State<UserDrawerWidget> createState() => _UserDrawerWidgetState();
}

class _UserDrawerWidgetState extends State<UserDrawerWidget> {
  final user = FirebaseAuth.instance.currentUser!;

  void _logout() {
    final provider = Provider.of<GoogleSigninProvider>(context, listen: false);
    provider.logout();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(IconHelper.historyOfOrders),
            title: const Text('Istorija porudzbina'),
            onTap: () {},
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            leading: Icon(IconHelper.logout),
            title: const Text('Logout'),
            onTap: () => _logout(),
          ),
        ],
      ),
    );
  }
}

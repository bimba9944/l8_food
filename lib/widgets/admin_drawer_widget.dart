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

  _goToAddFoodScreen(){
    Navigator.pushNamed(context, '/AddFoodScreen');
  }

   _goToUpdateFoodScreen(){
    Navigator.pushNamed(context, '/UpdateFoodScreen');
  }

  _logout(){
  final provider = Provider.of<GoogleSigninProvider>(context, listen: false);
  provider.logout();
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: ColorHelper.textColorWhite),
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
            leading: Icon(IconHelper.listAllOrders),
            onTap: () {},
            title: const Text('Predgled svih porudzbina'),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            leading: Icon(IconHelper.addMeal),
            onTap: () => _goToAddFoodScreen(),
            title: const Text('Dodavanje u jelovnik'),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            leading: Icon(IconHelper.updateMeal),
            onTap: () => _goToUpdateFoodScreen(),
            title: const Text('Izmena jelovnika'),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            leading: Icon(IconHelper.exportInPdf),
            onTap: () {},
            title: const Text('Izvezi sve u PDF'),
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

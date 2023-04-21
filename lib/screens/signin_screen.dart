import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:l8_food/helpers/language_helper.dart';
import 'package:l8_food/screens/admin_screen.dart';
import 'package:l8_food/screens/home_screen.dart';
import 'package:l8_food/widgets/signin_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool? data;

  Widget _checkIsUserAdmin(){
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    final ref = db.collection('users').doc(user?.uid);
    ref.get().then((DocumentSnapshot doc) {
      data = doc['admin'] as bool; //TODO then skloni i ovu metodu u poserban servis
    });
    return data == true ? AdminScreen() : HomeScreen();
  }

  Widget _login(context, snapshot){
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (snapshot.hasData) {
      return _checkIsUserAdmin();
    } else if (snapshot.hasError) {
      return  Center(
        child: Text(AppLocale.errorMessage.getString(context)),
      );
    } else {
      return const SignInWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: _login
      ),
    );
  }
}

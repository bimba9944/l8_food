import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:l8_food/screens/admin_screen.dart';
import 'package:l8_food/screens/home_screen.dart';
import 'package:l8_food/widgets/signin_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot)  {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final FirebaseFirestore _db = FirebaseFirestore.instance;
            final user = FirebaseAuth.instance.currentUser;

            final ref = _db.collection('users').doc(user?.uid);
            ref.get().then((DocumentSnapshot doc) {
             data = doc['admin'] as bool;
            });
            return data == true ? HomeScreen() : AdminScreen();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          } else {
            return const SigninWidget();
          }
        },
      ),
    );
  }
}

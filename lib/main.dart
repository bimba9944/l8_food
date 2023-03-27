import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:l8_food/helpers/google_signin.dart';
import 'package:l8_food/screens/admin_add_food_screen.dart';
import 'package:l8_food/screens/admin_update_food_screen.dart';
import 'package:l8_food/screens/signin_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => GoogleSigninProvider(),
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SigninScreen(),
        '/AddFoodScreen': (context) => const AdminAddFoodScreen(),
        '/UpdateFoodScreen': (context) => const AdminUpdateFoodScreen(),

      },
    ),
  );
}


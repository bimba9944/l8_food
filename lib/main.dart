import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:l8_food/helpers/app_routes.dart';
import 'package:l8_food/helpers/google_signin.dart';
import 'package:l8_food/screens/admin_add_food_screen.dart';
import 'package:l8_food/screens/admin_update_food_screen.dart';
import 'package:l8_food/screens/history_of_all_orders_screen.dart';
import 'package:l8_food/screens/history_of_orders_screen.dart';
import 'package:l8_food/screens/home_screen.dart';
import 'package:l8_food/screens/signin_screen.dart';
import 'package:provider/provider.dart';

import 'helpers/languages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;
  late String _languageCode;

  @override
  void initState() {
    _languageCode = 'sr';
    _localization.init(mapLocales: Languages.mapOfLanguages,
      initLanguageCode: _languageCode,
    );_localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }
  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => GoogleSignInProvider(),
    child: MaterialApp(
      supportedLocales: _localization.supportedLocales,
      localizationsDelegates: _localization.localizationsDelegates,
      debugShowCheckedModeBanner: false,
      title: 'LionEight Food',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //initialRoute: '/',
      routes: {
        AppRoutes.defaultRoute: (context) => const SignInScreen(),
        AppRoutes.addFood: (context) =>   const AdminAddFoodScreen(null),
        AppRoutes.updateFood: (context) => const AdminUpdateFoodScreen(),
        AppRoutes.homeScreen:(context) => const HomeScreen(),
        AppRoutes.historyOfOrders:(context) => const HistoryOfOrdersScreen(),
        AppRoutes.historyOfAllOrders:(context) => const HistoryOfAllOrdersScreen()
      },
    ),
  );
}


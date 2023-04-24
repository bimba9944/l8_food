import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:l8_food/helpers/firestore_manager.dart';
import 'package:l8_food/models/food_model.dart';
import 'package:l8_food/models/meals_model.dart';
import 'package:rxdart/rxdart.dart';

class MealsService {
  static MealsService? _instance;
  StreamSubscription? _mealsSubscription;
  List<MealsModel> _meals = [];
  final StreamController<List<MealsModel>> _mealsController = BehaviorSubject();
  final _user = FirebaseAuth.instance.currentUser!;
  final String dateFormatString = 'EEEE';

  static MealsService get instance {
    _instance ??= MealsService();
    return _instance!;
  }

  Stream<List<MealsModel>> get mealsStream {
    return _mealsController.stream;
  }

  void clearFoodStream() {
    _mealsSubscription?.cancel();
    _mealsSubscription = null;
  }

  void setupMealsStream(String docName,dynamic item,String collectionPath) {
   FirestoreManager.instance
        .addNewDocumentItem(
      docName: docName,
      item: item,
      collectionPath: collectionPath,
    );
  }
}
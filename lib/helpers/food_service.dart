import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:l8_food/helpers/firestore_manager.dart';
import 'package:l8_food/models/food_model.dart';
import 'package:rxdart/rxdart.dart';

class FoodService {
  static FoodService? _instance;
  StreamSubscription? _foodSubscription;
  List<FoodModel> _historyOfOrders = [];
  List<FoodModel> _historyOfAllOrders = [];
  List<FoodModel> _orders = [];
  final StreamController<List<FoodModel>> _historyOfOrdersController = BehaviorSubject();
  final StreamController<List<FoodModel>> _historyOfAllOrdersController = BehaviorSubject();
  final StreamController<List<FoodModel>> _ordersController = BehaviorSubject();
  final _user = FirebaseAuth.instance.currentUser!;
  final String dateFormatString = 'EEEE';

  static FoodService get instance {
    _instance ??= FoodService();
    return _instance!;
  }

  Stream<List<FoodModel>> get historyOfOrdersStream {
    return _historyOfOrdersController.stream;
  }
  Stream<List<FoodModel>> get historyOfAllOrdersStream {
    return _historyOfAllOrdersController.stream;
  }

  Stream<List<FoodModel>> get ordersStream {
    return _ordersController.stream;
  }

  void clearFoodStream() {
    _foodSubscription?.cancel();
    _foodSubscription = null;
  }

  List<String> _convertDateTime() {
    List<String> days = [];
    for (var day in _generateDate(5)) {
      days.add('${DateFormat(dateFormatString).format(day)},${day.day}.${day.month}.${day.year}');
    }
    return days;
  }

  List<DateTime> _generateDate(int count) {
    int weekends = 0;
    return List.generate(
      count,
          (index) {
        DateTime tempDate =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: index + weekends));
        if (tempDate.weekday > 5) {
          int offset = 7 - tempDate.weekday + 1;
          tempDate = tempDate.add(Duration(days: offset));
          weekends += offset;
        }
        return tempDate;
      },
    );
  }

  void setupHistoryOfOrdersStream() {
    _foodSubscription ??= FirestoreManager.instance
        .getCollectionStream(
      collectionPath: "orders",
      queryBuilder: (CollectionReference<Map<String, dynamic>> collection) {
        return collection.where('userId', isEqualTo: _user.uid);
      },
    )
        .listen((dynamic event) {
      _historyOfOrders = [];
      for (var document in event.docs) {
        _historyOfOrders.add(FoodModel.fromDocument(document: document));
      }
      _historyOfOrdersController.add(_historyOfOrders.map((e) => e.clone()).toList());
    });
  }

  void setupHistoryOfAllOrdersStream() {
    _foodSubscription ??= FirestoreManager.instance
        .getCollectionStream(
      collectionPath: "orders",
      queryBuilder: (CollectionReference<Map<String, dynamic>> collection) {
        return collection.where('date', whereIn: _convertDateTime());
      },
    )
        .listen((dynamic event) {
      _historyOfAllOrders = [];
      for (var document in event.docs) {
        _historyOfAllOrders.add(FoodModel.fromDocument(document: document));
      }
      _historyOfAllOrdersController.add(_historyOfAllOrders.map((e) => e.clone()).toList());
    });
  }

  void setupOrdersStream(controller) {
    _foodSubscription ??= FirestoreManager.instance
        .getCollectionStream(
      collectionPath: "orders",
      queryBuilder: (CollectionReference<Map<String, dynamic>> collection) {
        return collection.where('userId', isEqualTo: _user.uid).where('indexOfDay',isEqualTo: controller).where('date',isEqualTo: _convertDateTime()[controller]);
      },
    )
        .listen((dynamic event) {
      _orders = [];
      for (var document in event.docs) {
        _orders.add(FoodModel.fromDocument(document: document));
      }
      _ordersController.add(_orders.map((e) => e.clone()).toList());
    });
  }
}

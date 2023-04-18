import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/models/dropdown_items_model.dart';
import 'package:l8_food/widgets/admin_drawer_widget.dart';
import 'package:l8_food/widgets/appbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:l8_food/widgets/home_page_view_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser!;
  final dayDate = DateTime.now();
  late TabController _controller;
  late bool enabled = true;
  late var indexOfDay = _controller.index;
  int? indexOfMeal;
  bool enableButton = true;
  bool expired = true;
  late var dayOfOrder;

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 5);
    _controller.index = _setInitialIndex();
    _getMealsFromDb();
    _controller.addListener(() {
      _isExpired();
      _getMealsFromDb();
    });
    super.initState();
  }

  List<DateTime> generateDate(int count) {
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

  void _isExpired() {
    if (_controller.index <= DateTime.now().weekday - 1) {
      expired = true;
    } else {
      expired = false;
    }
  }

  void _getMealsFromDb() async {
    try {
      QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .where('indexOfDay', isEqualTo: _controller.index).where('date',isEqualTo: _convertDateTime()[_controller.index])
          .get();
      indexOfMeal = value.docs.first.data().values.elementAt(2);
      indexOfDay = value.docs.first.data().values.elementAt(1);
      dayOfOrder = value.docs.first.data().values.elementAt(0);
      print(generateDate(5)[_controller.index]);
    } catch (_) {
      enabled = true;
      enableButton = true;
      indexOfMeal = null;
    }
    if (indexOfMeal != null) {
      enabled = false;
      enableButton = false;
    }
    _setInitialIndex();
    setState(() {});
  }

  List<Widget> _buildTabBarDays() {
    List<Widget> days1 = [];
    for (var day in generateDate(5)) {
      days1.add(
        Tab(
          child: Column(
            children: [
              Text(DateFormat('EEEE').format(day)),
              Text('${day.day}.${day.month}.${day.year}'),
            ],
          ),
        ),
      );
    }
    return days1;
  }

  List<String> _convertDateTime() {
    List<String> dayss = [];
    for (var day in generateDate(5)) {
      dayss.add( '${DateFormat('EEEE').format(day)}'+','+'${day.day}.${day.month}.${day.year}'
      );
    }
    return dayss;
  }

  void _setValueForEnable(bool value) {
    enabled = value;
    enableButton = value;
    setState(() {});
  }

  void _setEnabled(bool value) {
    enabled = value;
    setState(() {});
  }

  void _setIndexOfMeal(int i) {
    indexOfMeal = i;
    setState(() {});
  }

  AppBarWidget _buildAppbar() {
    return AppBarWidget(
      tabBar: TabBar(
        controller: _controller,
        isScrollable: true,
        tabs: _buildTabBarDays(),
      ),
    );
  }

  int _setInitialIndex() {
    int initialIndex = 0;
    final hours = DateTime.now().hour;
    final day = DateTime.now().weekday;
    for (int i = 1; i <= DropdownItemsModel.list.length; i++) {
      if (hours >= 8 && day == i) {
        initialIndex = i - 1;
        break;
      }
    }
    return initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 5,
        initialIndex: _setInitialIndex(),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: _buildAppbar(),
          ),
          endDrawer: const AdminDrawerWidget(),
          body: HomePageSingleTabBarView(
            setInitialIndex: _setInitialIndex,
            controller: _controller,
            enableButton: enableButton,
            enabled: enabled,
            expired: expired,
            indexOfMeal: indexOfMeal,
            count: 5,
            generateDate: _convertDateTime,
            indexOfDay: indexOfDay,
            setValueForEnable: _setValueForEnable,
            setEnabled: _setEnabled,
            setIndexOfMeal: _setIndexOfMeal,
          ),
        ),
      ),
    );
  }
}

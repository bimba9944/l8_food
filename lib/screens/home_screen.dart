import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final _user = FirebaseAuth.instance.currentUser!;
  late TabController _controller;
  late bool _enabled = true;
  late var _indexOfDay = _controller.index;
  int? _indexOfMeal;
  bool _enableButton = true;
  bool _expired = true;
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
      _expired = true;
    } else {
      _expired = false;
    }
  }

  void _getMealsFromDb() async {
    try {
      //TODO U poseban servis
      QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: _user.uid)
          .where('indexOfDay', isEqualTo: _controller.index).where('date',isEqualTo: _convertDateTime()[_controller.index])
          .get();
      _indexOfMeal = value.docs.first.data().values.elementAt(2);
      _indexOfDay = value.docs.first.data().values.elementAt(1);
      dayOfOrder = value.docs.first.data().values.elementAt(0);
    } catch (_) {
      _enabled = true;
      _enableButton = true;
      _indexOfMeal = null;
    }
    if (_indexOfMeal != null) {
      _enabled = false;
      _enableButton = false;
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

  //TODO ovo EEEE imas na dosta mesta i video sam jos jednom u drugom fajlu gore, Vidi posto radis sa datumima na par mesta da napravis DateHelper i tu da imas metode koje ce da obraduju datume

  List<String> _convertDateTime() {
    List<String> dayss = [];
    for (var day in generateDate(5)) {
      dayss.add( '${DateFormat('EEEE').format(day)}'+','+'${day.day}.${day.month}.${day.year}'
      );
    }
    return dayss;
  }

  void _setValueForEnable(bool value) {
    _enabled = value;
    _enableButton = value;
    setState(() {});
  }

  void _setEnabled(bool value) {
    _enabled = value;
    setState(() {});
  }

  void _setIndexOfMeal(int i) {
    _indexOfMeal = i;
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
            enableButton: _enableButton,
            enabled: _enabled,
            expired: _expired,
            indexOfMeal: _indexOfMeal,
            count: 5,
            generateDate: _convertDateTime,
            indexOfDay: _indexOfDay,
            setValueForEnable: _setValueForEnable,
            setEnabled: _setEnabled,
            setIndexOfMeal: _setIndexOfMeal,
          ),
        ),
      ),
    );
  }
}

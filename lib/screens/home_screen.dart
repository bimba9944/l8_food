import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/models/dropdown_items_model.dart';
import 'package:l8_food/widgets/admin_drawer_widget.dart';
import 'package:l8_food/widgets/appbar_widget.dart';
import 'package:intl/intl.dart';

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
  late bool isSelected = true;
  bool enableButton = true;
  bool expired = true;
  late var dayOfOrder;

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

  void _isExpired() {
    if (_controller.index <= DateTime.now().weekday-1) {
      expired = true;
    } else {
      expired = false;
    }
  }

  void _getMealsFromDb() {
    FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .where('indexOfDay', isEqualTo: _controller.index)
        .get()
        .then((value) {
      indexOfMeal = value.docs.first.data().values.elementAt(2);
      indexOfDay = value.docs.first.data().values.elementAt(1);
      dayOfOrder = value.docs.first.data().values.elementAt(0);
      if (indexOfMeal != null) {
        enabled = false;
        enableButton = false;
      }
    }).catchError((error) {
      enabled = true;
      enableButton = true;
      indexOfMeal = null;
    });

    setState(() {
      _setInitialIndex();
    });
  }

  Color _isChecked(index) {
    if (indexOfMeal == null) {
      return const Color.fromRGBO(255, 255, 204, 0.7);
    } else if (indexOfMeal == index) {
      return const Color.fromRGBO(255, 204, 153, 1);
    }
    return Colors.white;
  }

  Future<void> _onTap(data, int? index, value) async {
    if (_setInitialIndex() + 1 >= data) {
      setState(() {
        enabled = false;
      });
    } else if (indexOfMeal == null) {
      setState(() {
        indexOfMeal = index!.ceil();
        isSelected = true;
      });
    } else if (isSelected == false && enabled == true) {
      setState(() {
        indexOfMeal = index;
        isSelected = true;
      });
    } else if (isSelected == true && enabled == true) {
      setState(() {
        isSelected = false;
        indexOfMeal = index;
      });
    }
  }

  List<Widget> _buildTabBarDays() {
    List<Widget> days1 = [];
    for (var day in generateDate(5)) {
      days1.add(Tab(text: '${day.day}.${day.month}.${day.year}'));
    }
    return days1;
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

  List<String> _listOfMeals(data) {
    List<String> meals = [];
    for (var item in data['hrana']) {
      meals.add(item);
    }
    return meals;
  }

  void _submitChoice() {
    if (enabled && enableButton) {
      FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'date': dayDate,
        'indexOfDay': _controller.index,
        'index': indexOfMeal,
      });
      enableButton = false;
      enabled = false;
    } else {
      return deactivate();
    }
    setState(() {});
  }

  Future<void> _editChoice() async {
    enableButton = true;
    enabled = true;
    var snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .where('index', isEqualTo: indexOfMeal)
        .where('indexOfDay', isEqualTo: indexOfDay)
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    setState(() {});
  }

  Text _buildText() {
    setState(() {});
    return Text('Proslo je vreme za narucivanje');
  }

  Widget _buildButtons() {
    if (expired) {
      setState(() {});
      return _buildText();
    }
    if (enableButton && enabled) {
      setState(() {});
      return ElevatedButton(child: const Text('Submit'), onPressed: () => _submitChoice());
    }
    if (!enableButton && !enabled) {
      setState(() {});
      return ElevatedButton(onPressed: () => _editChoice(), child: const Text('Edit'));
    }
    return Text('Nesto');
  }

  Widget _buildTabBarView(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) {
      return Text('Something went wrong');
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _controller,
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return ListView.builder(
          itemCount: _listOfMeals(data).length,
          itemBuilder: (_, int index) {
            return ListTile(
              tileColor: _isChecked(index),
              title: GestureDetector(
                  onTap: () {
                    _onTap(data['index'], index, _listOfMeals(data)[index]);
                  },
                  child: Text(_listOfMeals(data)[index])),
            );
          },
        );
      }).toList(),
    );
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
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 1,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("days").orderBy('index').snapshots(),
                  builder: _buildTabBarView,
                ),
              ),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

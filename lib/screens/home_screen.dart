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
  final dayDate = DateFormat('EEEE,d.MMMM').format(DateTime.now());
  late TabController _controller;
  late bool enabled;
  final List<bool> selected = List.generate(12, (index) => false);
  late var indexOfDay = _controller.index;
  late int? indexOfMeal = 2;

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 5);
    _controller.index = _setInitialIndex();
    _controller.addListener(() {
      FirebaseFirestore.instance
          .collection('orders')
          .where('indexOfDay', isEqualTo: _controller.index)
          .get()
          .then((value) {
            print(value.docs.first.data().values);
        indexOfMeal = value.docs.first.data().values.elementAt(2);
        indexOfDay = value.docs.first.data().values.elementAt(1);
        selected[indexOfMeal!] = true;
      }).catchError((error) => indexOfMeal = null);
      setState(() {});
    });
    super.initState();
  }

  Color _isChecked(index){
    if(indexOfMeal == null || !selected[indexOfMeal!]){
      return const Color.fromRGBO(255, 255, 204, 0.7);
    }else if(indexOfMeal == index){
      return const Color.fromRGBO(255, 204, 153, 1);
    }
    return Colors.white;
  }

  Future<void> _onTap(data,int? index,value) async {
    if (_setInitialIndex() + 1 >= data) {
      setState(() {
        enabled = false;
      });
    } else if(indexOfMeal == null || selected[indexOfMeal!] == false){
      setState(() {
        indexOfMeal = index;
        enabled = true;
        selected[indexOfMeal!] = !selected[indexOfMeal!];
        FirebaseFirestore.instance.collection('orders').add({
          'defVal': value,
          'userId': user.uid,
          'date': dayDate,
          'indexOfDay': _controller.index,
          'index': index,
        });
      });
    }
    else if(selected[indexOfMeal!] == true){
      indexOfMeal = index;
      enabled = true;
      selected[indexOfMeal!] = !selected[indexOfMeal!];
      var snapshot = await FirebaseFirestore.instance.collection('orders').where('index' ,isEqualTo: indexOfMeal).where('indexOfDay', isEqualTo: indexOfDay).get();
      for(var doc in snapshot.docs){
        await doc.reference.delete();
      }
      _isChecked(index);
      setState(() {

      });
    }
  }

  List<Widget> _buildTabBarDays() {
    List<Widget> days = [];
    for (String day in DropdownItemsModel.list) {
      days.add(Tab(text: day));
    }
    return days;
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




  Widget _buildTabBarView(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) {
      return Text('Something went wrong');
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text("Loading");
    }
    return TabBarView(
      controller: _controller,
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return Card(
            margin: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                side: BorderSide(color: ColorHelper.listTileBorder)),
            elevation: 10,
            child: ListView.builder(
              itemCount: _listOfMeals(data).length,
              prototypeItem: ListTile(title: Text(_listOfMeals(data).first)),
              itemBuilder: (_, int index) {
                return ListTile(
                  tileColor: _isChecked(index),
                  title: GestureDetector(
                      onTap: () {
                        _onTap(data['index'],index,_listOfMeals(data)[index]);
                      },
                      child: Text(_listOfMeals(data)[index])),
                );
              },
            ));
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
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("days").orderBy('index').snapshots(),
            builder: _buildTabBarView,
          ),
        ),
      ),
    );
  }
}

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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  String _defVal = '/';
  final user = FirebaseAuth.instance.currentUser!;
  final dayDate = DateFormat('EEEE,d.MMMM').format(DateTime.now());
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 5);
    _controller.addListener(() { print('nesto');});
    super.initState();
  }

  AppBarWidget _buildAppbar() {
    return AppBarWidget(
      tabBar: TabBar(
        isScrollable: true,
        tabs: [
          Tab(text: DropdownItemsModel.list[0]),
          Tab(text: DropdownItemsModel.list[1]),
          Tab(text: DropdownItemsModel.list[2]),
          Tab(text: DropdownItemsModel.list[3]),
          Tab(text: DropdownItemsModel.list[4]),
        ],
      ),
    );
  }

  int _setInitialIndex() {
    int initialIndex = 0;
    final now = DateFormat('EEEE,hh:mm').format(DateTime.now());
    final monday = DateFormat('EEEE,hh:mm').parse('Monday,08:00');
    final tuesday = DateFormat('EEEE,hh:mm').parse('Tuesday,08:00');
    final wednesday = DateFormat('EEEE,hh:mm').parse('Wednesday,08:00');
    final thursday = DateFormat('EEEE,hh:mm').parse('Thursday,08:00');
    final friday = DateFormat('EEEE,hh:mm').parse('Friday,08:00');
    final saturday = DateFormat('EEEE,hh:mm').parse('Saturday,08:00');
    final sunday = DateFormat('EEEE,hh:mm').parse('Sunday,08:00');
    final nowInString = DateFormat('EEEE,hh:mm').parse(now);
    print(nowInString);
    if (nowInString.compareTo(monday) == 1) {
      initialIndex = 0;
    } else if (nowInString.compareTo(tuesday) == 1) {
      initialIndex = 1;
    } else if (nowInString.compareTo(wednesday) == 1) {
      initialIndex = 2;
    } else if (nowInString.compareTo(thursday) == 1) {
      initialIndex = 3;
    } else if (nowInString.compareTo(friday) == 1) {
      initialIndex = 4;
    } else if (nowInString.compareTo(saturday) == 1) {
      initialIndex = 0;
    } else if (nowInString.compareTo(sunday) == 1) {
      initialIndex = 0;
    }
    return initialIndex;
  }

  List<Widget> _buildMenu(data) {
    List<Widget> items = [];
    for (var item in data['hrana']) {
      print(data['hrana']);
      items.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          ListTile(
            title: Text(item.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
            leading: Radio<String>(
              value: item,
              groupValue: _defVal,
              toggleable: true,
              onChanged: _setInitialIndex() + 1 >= data['index']
                  ? null
                  : (value) {
                      FirebaseFirestore.instance
                          .collection('orders')
                          .add({'defVal': value.toString(), 'userId': user.uid, 'date': dayDate});
                      _defVal = value.toString();
                      setState(() {
                        _defVal = value.toString();
                      });
                    },
            ),
          ),
        ]),
      ));
    }
    return items;
  }

  Widget _buildTabBarView(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) {
      return Text('Something went wrong');
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text("Loading");
    }
    return TabBarView(
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return Card(
            margin: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                side: BorderSide(color: ColorHelper.listTileBorder)),
            elevation: 10,
            child: ListView(
              children: [..._buildMenu(data)],
            ));
      }).toList(),
    //controller: _controller,
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

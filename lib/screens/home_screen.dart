import 'package:cloud_firestore/cloud_firestore.dart';
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

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
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
    if (DateFormat('EEEE').format(DateTime.now()) == 'Wednesday') {
      initialIndex = 2;
    } else if (DateFormat('EEEE').format(DateTime.now()) == 'Monday') {
      initialIndex = 0;
    } else if (DateFormat('EEEE').format(DateTime.now()) == 'Tuesday') {
      initialIndex = 1;
    } else if (DateFormat('EEEE').format(DateTime.now()) == 'Thursday') {
      initialIndex = 3;
    } else if (DateFormat('EEEE').format(DateTime.now()) == 'Friday') {
      initialIndex = 4;
    }
    return initialIndex;
  }

  List<Widget> _buildMenu(data){
    List<Widget> items = [];
    for (var item in data['hrana']) {
          items.add(Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  side: BorderSide(color: ColorHelper.listTileBorder)),
              elevation: 10,
              child: ListTile(
                contentPadding: const EdgeInsets.all(6),
                title: Text(item.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ));
    }
    return items;
  }

  Widget _buildTabBarView(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
    if (snapshot.hasError) {
      return Text('Something went wrong');
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text("Loading");
    }
    return TabBarView(
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return ListView(children: [..._buildMenu(data)],);
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

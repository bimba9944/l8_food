import 'package:flutter/material.dart';
import 'package:l8_food/models/dropdown_items_model.dart';
import 'package:l8_food/widgets/admin_drawer_widget.dart';
import 'package:l8_food/widgets/appbar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class MyItem {
  MyItem({ this.isExpanded = false, required this.header, required this.body });
  bool isExpanded;
  final String header;
  final String body;
}

class _HomeScreenState extends State<HomeScreen> {
  final List<MyItem> items = [];

  @override
  void initState() {
    _buildTiles();
    super.initState();
  }


  List<MyItem> _buildTiles(){
    for(var i in DropdownItemsModel.list){
      items.add(MyItem(header: i.toString(), body: 'body'),);
    }
    return items;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBarWidget(null),
        ),
        endDrawer: const AdminDrawerWidget(),
        body: Column(
          children: [
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    items[index].isExpanded = !items[index].isExpanded;
                  });
              },
              children: items.map((MyItem item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Text(item.header);
                  },
                  isExpanded: item.isExpanded,
                  body:  const Text("body"),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

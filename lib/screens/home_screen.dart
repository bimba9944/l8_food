import 'package:flutter/material.dart';
import 'package:l8_food/widgets/admin_drawer_widget.dart';
import 'package:l8_food/widgets/appbar_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum Fruit { apple, banana }

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<Fruit> _selectedItem =  ValueNotifier<Fruit>(Fruit.apple);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBarWidget(null),
        ),
        endDrawer: const AdminDrawerWidget(),
        body: Center(
          child: Container(
            child: PopupMenuButton<Fruit>(
              child: Text('Ponedeljak'),
              itemBuilder: (BuildContext context) {
                return List<PopupMenuEntry<Fruit>>.generate(2, (index) {
                  return PopupMenuItem(
                      value: Fruit.values![index],
                      child: AnimatedBuilder(
                        builder: (BuildContext context, Widget? child) {
                          return RadioListTile<Fruit>(
                              value: Fruit.values[index],
                              title: child,
                              groupValue: _selectedItem.value,
                              onChanged: (Fruit? value) {
                                setState(() {
                                  _selectedItem.value = value!;
                                });
                              });
                        },
                        animation: _selectedItem,
                        child: Text(Fruit.values[index].toString()),
                      ));
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

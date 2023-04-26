import 'package:flutter/material.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:l8_food/models/food_model.dart';
import 'package:l8_food/widgets/appbar_widget.dart';
import '../helpers/food_service.dart';

class HistoryOfOrdersScreen extends StatefulWidget {
  const HistoryOfOrdersScreen({Key? key}) : super(key: key);

  @override
  State<HistoryOfOrdersScreen> createState() => _HistoryOfOrdersScreenState();
}

class _HistoryOfOrdersScreenState extends State<HistoryOfOrdersScreen> {
  final List<String> _allMeals = [];
  final List<String> _allDates = [];

  @override
  void initState() {
    FoodService.instance.setupHistoryOfOrdersStream();
    FoodService.instance.historyOfOrdersStream.listen(_getHistoryOfOrders);
    super.initState();
  }

  void _getHistoryOfOrders(List<FoodModel> orders) {
    for (var order in orders) {
      _allMeals.add(order.defVal);
      _allDates.add(order.date);
    }
    setState(() {});
  }


  ListTile _buildListTile(index) {
    return ListTile(
      title: Text(_allDates[index]),
      subtitle: Text(_allMeals[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBarWidget(
            iconButton: IconButton(
              icon: Icon(IconHelper.appBarBackIcon),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: _allMeals.length,
                itemBuilder: (context, int index) => _buildListTile(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

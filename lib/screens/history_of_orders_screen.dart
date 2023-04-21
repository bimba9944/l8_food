import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:l8_food/widgets/appbar_widget.dart';

class HistoryOfOrdersScreen extends StatefulWidget {
  const HistoryOfOrdersScreen({Key? key}) : super(key: key);

  @override
  State<HistoryOfOrdersScreen> createState() => _HistoryOfOrdersScreenState();
}

class _HistoryOfOrdersScreenState extends State<HistoryOfOrdersScreen> {
  final _user = FirebaseAuth.instance.currentUser!;
  final List<String> _allMeals = [];
  final List<String> _allDates = [];

  @override
  void initState() {
    _getMeals();
    super.initState();
  }

  Future<void> _getMeals() async {
    //TODO u posebnu klasu, ne koristi then nego await
    await FirebaseFirestore.instance.collection('orders').where('userId', isEqualTo: _user.uid).get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          _allMeals.add('${docSnapshot.data().values.last}');
          _allDates.add(docSnapshot.data().values.first);
        }
      },
    );

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

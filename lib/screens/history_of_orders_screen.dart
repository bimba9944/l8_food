import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:l8_food/widgets/appbar_widget.dart';

class HistoryOfOrdersScreen extends StatefulWidget {
  const HistoryOfOrdersScreen({Key? key}) : super(key: key);

  @override
  State<HistoryOfOrdersScreen> createState() => _HistoryOfOrdersScreenState();
}

class _HistoryOfOrdersScreenState extends State<HistoryOfOrdersScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  List<String> allMeals = [];
  List<String> allDates = [];

  @override
  void initState() {
    _getMeals();
    super.initState();
  }

  Future<void> _getMeals() async {
    await FirebaseFirestore.instance.collection('orders').where('userId', isEqualTo: user.uid).get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          allMeals.add('${docSnapshot.data().values.last}');
          allDates.add(docSnapshot.data().values.first);
          print(docSnapshot.data().values.first);
        }
      },
    );

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBarWidget(
            iconButton: IconButton(
              icon: Icon(IconHelper.appbarbackIcon),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: allMeals.length,
                itemBuilder: (context, int index) {
                  return ListTile(
                    title: Text(allDates[index]),
                    subtitle: Text(allMeals[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

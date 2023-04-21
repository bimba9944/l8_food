import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:l8_food/helpers/language_helper.dart';

class HomePageSingleTabBarView extends StatefulWidget {
  const HomePageSingleTabBarView({
    super.key,
    required this.setInitialIndex,
    required this.controller,
    required this.expired,
    required this.enableButton,
    required this.enabled,
    required this.indexOfMeal,
    required this.indexOfDay,
    required this.count,
    required this.generateDate,
    required this.setValueForEnable,
    required this.setEnabled,
    required this.setIndexOfMeal,
  });

  final TabController controller;
  final Function() setInitialIndex;
  final Function() generateDate;
  final Function(bool value) setValueForEnable;
  final Function(bool value) setEnabled;
  final Function(int i) setIndexOfMeal;
  final bool enabled;
  final int? indexOfMeal;
  final bool enableButton;
  final bool expired;
  final int indexOfDay;
  final int count;

  @override
  State<HomePageSingleTabBarView> createState() => _HomePageSingleTabBarViewState();
}

class _HomePageSingleTabBarViewState extends State<HomePageSingleTabBarView> {
  String? _de0fVal;
  final _user = FirebaseAuth.instance.currentUser!;
  late bool _isSelected = true;

  List<String> _listOfMeals(data) {
    List<String> meals = [];
    for (var item in data['hrana']) { //TODO izdvoj ovo hrana nekako, da ne stoji random u kodu
      meals.add(item);
    }
    return meals;
  }


  Future<void> _editChoice() async {
    widget.setValueForEnable(true);
    //TODO prebaci u servis
    var snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: _user.uid)
        .where('index', isEqualTo: widget.indexOfMeal)
        .where('indexOfDay', isEqualTo: widget.indexOfDay)
        .where('defVal', isEqualTo: _de0fVal)
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    setState(() {});
  }

  void _submitChoice() {
    if (widget.enabled && widget.enableButton) {
      //TODO prebaci u servis
      FirebaseFirestore.instance.collection('orders').add({
        'defVal': _de0fVal,
        'userId': _user.uid,
        'date': widget.generateDate()[widget.controller.index],
        'indexOfDay': widget.controller.index,
        'index': widget.indexOfMeal,
        'email': _user.email
      });
      widget.setValueForEnable(false);
    } else {
      return deactivate();
    }
    setState(() {});
  }

  Color _isChecked(index) {
    if (widget.indexOfMeal == null) {
      return Colors.white;
    } else if (widget.indexOfMeal == index) {
      return Colors.lightBlueAccent;
    }
    return Colors.white;
  }

  Future<void> _onTap(data, int index, value) async {
    if (widget.setInitialIndex() + 1 >= data) {
      setState(() {
        widget.setEnabled(false);
      });
    } else if (widget.indexOfMeal == null) {
      setState(() {
        _de0fVal = value;
        widget.setIndexOfMeal(index);
        _isSelected = true;
      });
    } else if (_isSelected == false && widget.enabled == true) {
      setState(() {
        _de0fVal = value;
        widget.setIndexOfMeal(index);
        _isSelected = true;
      });
    } else if (_isSelected == true && widget.enabled == true) {
      setState(() {
        _de0fVal = value;
        _isSelected = false;
        widget.setIndexOfMeal(index);
      });
    }
  }

  void _onClick(data,index){
    _onTap(data['index'], index, _listOfMeals(data)[index]);
  }

  Widget _buildTabBarView(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) {
      return Text(AppLocale.errorMessage.getString(context));
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: widget.controller,
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return ListView.builder(
          itemCount: _listOfMeals(data).length,
          itemBuilder: (_, int index) {
            return ListTile(
              tileColor: _isChecked(index),
              title: GestureDetector(
                  onTap: () => _onClick(data, index),
                  child: Text(_listOfMeals(data)[index])),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildButtons() {
    if (widget.expired) {
      setState(() {});
      return _buildText();
    }
    if (widget.enableButton && widget.enabled) {
      setState(() {});
      return ElevatedButton(child:  Text(AppLocale.submitButton.getString(context)), onPressed: () => _submitChoice());
    }
    if (!widget.enableButton && !widget.enabled) {
      setState(() {});
      return FloatingActionButton(
          backgroundColor: Colors.blue, onPressed: () => _editChoice(), child: const Icon(Icons.edit));
    }
    return const Text(''); //
  }

  Text _buildText() {
    setState(() {});
    return Text(AppLocale.expiredTime.getString(context));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

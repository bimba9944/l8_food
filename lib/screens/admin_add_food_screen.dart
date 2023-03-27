import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:l8_food/helpers/snackBarHelper.dart';
import 'package:l8_food/models/dropdown_items_model.dart';
import 'package:l8_food/widgets/appbar_widget.dart';
import 'package:l8_food/widgets/dropdown_button.dart';

class AdminAddFoodScreen extends StatefulWidget {
  const AdminAddFoodScreen({Key? key}) : super(key: key);

  @override
  State<AdminAddFoodScreen> createState() => _AdminAddFoodScreenState();
}

class _AdminAddFoodScreenState extends State<AdminAddFoodScreen> {

  String dropdownValue = DropdownItemsModel.list.first;

  late TextEditingController _controller;

  void _ifCanAddMeal(value) {
    SnackBarHelper.buildSnackBar('Uspesno ste dodali jelo.', context);
    _controller.text = '';
  }

  void _ifCantAddMeal(error) {
    SnackBarHelper.buildSnackBar(error, context);
  }

  void _addFood() async {
    if (_controller.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('days').doc(dropdownValue).set({
        'hrana' : FieldValue.arrayUnion([_controller.text]),
      }, SetOptions(merge: true)).then(_ifCanAddMeal).catchError(_ifCantAddMeal);
    } else {
      SnackBarHelper.buildSnackBar('Popunite polje za novo jelo!', context);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChangeDropdown(String? value){
    setState(() {
      dropdownValue = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBarWidget(
            IconButton(
              icon: Icon(IconHelper.appbarbackIcon),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 60),
            DropdownButtonWidget(list: DropdownItemsModel.list, dropdownValue: dropdownValue, onChanged: _onChangeDropdown
            ,),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Dodajte novo jelo'),
              ),
            ),
            ElevatedButton(
              onPressed: () => _addFood(),
              style: ElevatedButton.styleFrom(primary: ColorHelper.addFoodButtonBackground),
              child: Text(
                'Submit',
                style: TextStyle(color: ColorHelper.textColorWhite),
              ),
            )
          ],
        ),
      ),
    );
  }
}

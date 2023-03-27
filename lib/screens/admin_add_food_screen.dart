import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:l8_food/helpers/snackBarHelper.dart';
import 'package:l8_food/widgets/appbar_widget.dart';
import 'package:l8_food/widgets/dropdown_button.dart';

class AdminAddFoodScreen extends StatefulWidget {
  const AdminAddFoodScreen({Key? key}) : super(key: key);

  @override
  State<AdminAddFoodScreen> createState() => _AdminAddFoodScreenState();
}

class _AdminAddFoodScreenState extends State<AdminAddFoodScreen> {
  static const List<String> list = <String>['Ponedeljak', 'Utorak', 'Sreda', 'Cetvrtak', 'Petak'];
  String dropdownValue = list.first;

  late TextEditingController _controller;

  void _addFood() async {
    if (_controller.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('days').doc(dropdownValue).set({
        'hrana' : FieldValue.arrayUnion([_controller.text]),
      }, SetOptions(merge: true)).then((value){
        SnackBarHelper.buildSnackBar('Uspesno ste dodali jelo.', context);
        _controller.text = '';
      }).catchError((error) {
        SnackBarHelper.buildSnackBar(error, context);
      });
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
            DropdownButtonWidget(list: list, dropdownValue: dropdownValue, onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },),
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

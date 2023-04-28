import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:l8_food/helpers/snackBarHelper.dart';
import 'package:l8_food/models/dropdown_items_model.dart';
import 'package:l8_food/widgets/delete_dialog_widget.dart';
import 'package:l8_food/widgets/dropdown_button.dart';
import 'package:l8_food/widgets/update_dialog_widget.dart';
import 'package:l8_food/widgets/appbar_widget.dart';

class AdminUpdateFoodScreen extends StatefulWidget {
  const AdminUpdateFoodScreen({Key? key}) : super(key: key);

  @override
  State<AdminUpdateFoodScreen> createState() => _AdminUpdateFoodScreenState();
}

class _AdminUpdateFoodScreenState extends State<AdminUpdateFoodScreen> {
  TextEditingController titleController = TextEditingController();

  String dropdownValue = DropdownItemsModel.list.first;
  List<String> data = [];

  void _ifCanGetAllMeals(DocumentSnapshot doc) {
    data = List.from(doc['hrana']);
    setState(() {
      data;
    });
  }

  void _cantGetAllMeals(error) {
    setState(() {
      data = [];
      _buildMenu();
    });
    SnackBarHelper.buildSnackBar('Ne postoji ni jedno jelo za izabrani dan', context);
  }

  void getAllMeals() {
    final docRef = FirebaseFirestore.instance.collection("days").doc(dropdownValue);
    docRef.get().then(_ifCanGetAllMeals).catchError(_cantGetAllMeals);
  }

  void _onUpdate(String controler, String oldValue) async {
    await FirebaseFirestore.instance.collection('days').doc(dropdownValue).update({
      'hrana': FieldValue.arrayRemove([oldValue])
    });
    await FirebaseFirestore.instance.collection('days').doc(dropdownValue).update(
      {
        'hrana': FieldValue.arrayUnion([controler])
      },
    );
    if (mounted) {
      Navigator.of(context).pop();
      setState(() {
        getAllMeals();
      });
    }
  }

  void _ifCanDelete(value) {
    Navigator.of(context).pop();
    setState(() {
      getAllMeals();
    });
  }

  void _onDelete(String oldValue) {
    FirebaseFirestore.instance.collection('days').doc(dropdownValue).update(
      {
        'hrana': FieldValue.arrayRemove([oldValue])
      },
    ).then(_ifCanDelete);
  }

  Future<String?> _showDialogForUpdate(item) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => UpdateDialogWidget(
        onPressed: _onUpdate,
        controller: titleController,
        oldValue: item.toString(),
      ),
    );
  }

  Future<String?> _showDialogForDelete(item) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => DeleteDialogWidget(
        onPressed: _onDelete,
        oldValue: item.toString(),
      ),
    );
  }

  List<Widget> _buildMenu() {
    List<Widget> items = [];
    for (var item in data) {
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () => _showDialogForUpdate(item), icon: Icon(IconHelper.updateMeal)),
                IconButton(onPressed: () => _showDialogForDelete(item), icon: Icon(IconHelper.deleteMeal))
              ],
            ),
          ),
        ),
      ));
    }
    return items;
  }

  @override
  void initState() {
    getAllMeals();
    super.initState();
  }

  void _onChangeDropdown(String? value) {
    setState(() {
      dropdownValue = value!;
    });
    getAllMeals();
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
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              DropdownButtonWidget(
                list: DropdownItemsModel.list,
                dropdownValue: dropdownValue,
                getData: getAllMeals,
                onChanged: _onChangeDropdown,
              ),
              ..._buildMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

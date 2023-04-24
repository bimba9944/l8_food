import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:l8_food/helpers/language_helper.dart';
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
  final TextEditingController _titleController = TextEditingController();

  String _dropdownValue = DropdownItemsModel.list.first;
  List<String> _data = [];
  List<String> data1 =[];

  @override
  void initState() {
    getAllMeals();
    super.initState();
  }

  void _ifCanGetAllMeals(DocumentSnapshot doc) {
    _data = List.from(doc['hrana']); //TODO izdvoj ovo hrana
    setState(() {
      _data;
    });
  }

  void _cantGetAllMeals(error) {
    setState(() {
      _data = [];
      _buildMenu();
    });
    SnackBarHelper.buildSnackBar(AppLocale.emptyMealsMessage.getString(context), context);
  }

  void getAllMeals() {
    final docRef = FirebaseFirestore.instance
        .collection("days")
        .doc(_dropdownValue); //TODO ista prica kao u google_signin.dart prebaci ovo u poseban servis
    docRef.get().then(_ifCanGetAllMeals).catchError(
        _cantGetAllMeals); //TODO ne koristi then nego await, ovo catchError mozes da stavis u try i catch i u catch delun da pozoves _cantGetAllMeals
  }

  void _onUpdate(String controler, String oldValue) async {
    //TODO sve ove firebase metode za update add delete sta vec, treba da budu u posebnom servisu, ako je moguce npr imas jednu update metodu koja je genericka i samo joj prosledjujes argumente odavde
    await FirebaseFirestore.instance.collection('days').doc(_dropdownValue).update({
      'hrana': FieldValue.arrayRemove([oldValue])
    });
    await FirebaseFirestore.instance.collection('days').doc(_dropdownValue).update(
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

  void _foodIsDeleted(value) {
    Navigator.of(context).pop();
    if(mounted){
      setState(() {
        getAllMeals();
      });
    }
  }

  void _onDelete(String oldValue) {
    //TODO opet :D svuda gde koristis firebase metode stavih ih u jedan servis i napravi da update, delete, insert metode budu genericke da mogu da prihvate bilo sta
    FirebaseFirestore.instance.collection('days').doc(_dropdownValue).update(
      {
        'hrana': FieldValue.arrayRemove([oldValue])
      },
    ).then(_foodIsDeleted); //TODO ne koristi then nego await
  }

  Future<String?> _showDialogForUpdate(item) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => UpdateDialogWidget(
        onPressed: _onUpdate,
        controller: _titleController,
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
    for (var item in _data) {
      items.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              side: BorderSide(color: ColorHelper.listTileBorder),
            ),
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
        ),
      );
    }
    return items;
  }


  void _onChangeDropdown(String? value) {
    setState(() {
      _dropdownValue = value!;
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
                dropdownValue: _dropdownValue,
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

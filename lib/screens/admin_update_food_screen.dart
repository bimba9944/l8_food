import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:l8_food/helpers/snackBarHelper.dart';
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
  static const List<String> list = <String>['Ponedeljak', 'Utorak', 'Sreda', 'Cetvrtak', 'Petak'];
  TextEditingController titleController = TextEditingController();

  String dropdownValue = list.first;
  List<String> data = [];

  void getDataOnce_getADocument() {
    final docRef = FirebaseFirestore.instance.collection("days").doc(dropdownValue);
    docRef.get().then(
      (DocumentSnapshot doc) {
        data = List.from(doc['hrana']);
        setState(() {
          data;
        });
      },
    ).catchError((error) {
      setState(() {
        data = [];
        _buildMenu();
      });
      SnackBarHelper.buildSnackBar('Ne postoji ni jedno jelo za izabrani dan', context);
    });
  }

  _onUpdate(String controler, String oldValue) {
    FirebaseFirestore.instance.collection('days').doc(dropdownValue).update(
      {
        'hrana': FieldValue.arrayRemove([oldValue])
      },
    ).then((value) {
      FirebaseFirestore.instance.collection('days').doc(dropdownValue).update(
        {
          'hrana': FieldValue.arrayUnion([controler])
        },
      ).then((value) {
        Navigator.of(context).pop();
        setState(() {
          getDataOnce_getADocument();
        });
      });
    });
  }

  _onDelete(String oldValue) {
    FirebaseFirestore.instance.collection('days').doc(dropdownValue).update(
      {
        'hrana': FieldValue.arrayRemove([oldValue])
      },
    ).then((value) {
      Navigator.of(context).pop();
      setState(() {
        getDataOnce_getADocument();
      });
    });
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
                IconButton(
                    onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => UpdateDialogWidget(
                            onPressed: _onUpdate,
                            controller: titleController,
                            oldValue: item.toString(),
                          ),
                        ),
                    icon: Icon(IconHelper.updateMeal)),
                IconButton(
                    onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => DeleteDialogWidget(
                            onPressed: _onDelete,
                            oldValue: item.toString(),
                          ),
                        ),
                    icon: Icon(IconHelper.deleteMeal))
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
    getDataOnce_getADocument();
    super.initState();
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
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              DropdownButtonWidget(list: list, dropdownValue: dropdownValue, getData: getDataOnce_getADocument, onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
                getDataOnce_getADocument();
              },),
              ..._buildMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

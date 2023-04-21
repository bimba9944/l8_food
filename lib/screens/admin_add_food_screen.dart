import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:l8_food/helpers/language_helper.dart';
import 'package:l8_food/helpers/snackBarHelper.dart';
import 'package:l8_food/models/dropdown_items_model.dart';
import 'package:l8_food/widgets/appbar_widget.dart';
import 'package:l8_food/widgets/dropdown_button.dart';

class AdminAddFoodScreen extends StatefulWidget {
  const AdminAddFoodScreen(this.refreshScreen, {Key? key}) : super(key: key);

  final Future? refreshScreen;

  @override
  State<AdminAddFoodScreen> createState() => _AdminAddFoodScreenState();
}

class _AdminAddFoodScreenState extends State<AdminAddFoodScreen> {
  String _dropdownValue =
      DropdownItemsModel.list.first;
  late TextEditingController _controller;

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

  dynamic _buildNotification(String message) {
    SnackBarHelper.buildSnackBar(message, context);
    _controller.text = '';
  }

  Future<void> _addMeal() async {
    //TODO ovo isto u poseban service, ista prica kao za google_signing.dart komentar
    FirebaseFirestore.instance.collection('days').doc(_dropdownValue).set({
      'hrana': FieldValue.arrayUnion([_controller.text]),
    }, SetOptions(merge: true));
    await (_buildNotification(
        AppLocale.successfullyUpdatedMeal.getString(context)));
  }

  Future<void> _addFood() async {
    try {
      if (_controller.text.isNotEmpty) {
        _addMeal();
        widget
            .refreshScreen;
      } else {
        _buildNotification(AppLocale.messageIfAddFoodFailed.getString(context));
      }
    } catch (error) {
      (_buildNotification(AppLocale.errorMessage.getString(context)));
    }
  }

  void _onChangeDropdown(String? value) {
    setState(() {
      _dropdownValue =
          value!;
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
              icon: Icon(IconHelper.appBarBackIcon),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 60),
            DropdownButtonWidget(
              list: DropdownItemsModel.list,
              dropdownValue: _dropdownValue,
              onChanged: _onChangeDropdown,
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                decoration:  InputDecoration(border: OutlineInputBorder(), labelText: AppLocale.updateMealTextField.getString(context)),
              ),
            ),
            ElevatedButton(
              onPressed: () => _addFood(),
              style: ElevatedButton.styleFrom(primary: ColorHelper.addFoodButtonBackground),
              child: Text(
                AppLocale.submitButton.getString(context),
                style: TextStyle(color: ColorHelper.textColorWhite),
              ),
            )
          ],
        ),
      ),
    );
  }
}

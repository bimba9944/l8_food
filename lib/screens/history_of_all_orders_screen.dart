import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:l8_food/helpers/food_service.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:l8_food/helpers/language_helper.dart';
import 'package:l8_food/models/food_model.dart';
import 'package:l8_food/widgets/appbar_widget.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class HistoryOfAllOrdersScreen extends StatefulWidget {
  const HistoryOfAllOrdersScreen({Key? key}) : super(key: key);

  @override
  State<HistoryOfAllOrdersScreen> createState() => _HistoryOfAllOrdersScreenState();
}

class _HistoryOfAllOrdersScreenState extends State<HistoryOfAllOrdersScreen> {
  final List<String> _allMeals = [];
  final List<String> _allDates = [];
  final List<String> _allEmails = [];
  final String pdfName = '/Output.pdf';

  @override
  void initState() {
    FoodService.instance.setupHistoryOfAllOrdersStream();
    FoodService.instance.historyOfAllOrdersStream.listen(_getHistoryOfAllOrders);
    super.initState();
  }

  void _getHistoryOfAllOrders(List<FoodModel> orders) {
    for (var order in orders) {
      _allMeals.add(order.defVal);
      _allDates.add(order.date);
      _allEmails.add(order.email);
    }
    setState(() {});
  }

  String _buildString(){
    var str = '';
    for(int i = 0;i < _allEmails.length; i++){
          str = '$str\n${_allEmails[i]}\n${_allDates[i]}\n${_allMeals[i]}';
    }
    return str;
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    document.pages.add().graphics.drawString(_buildString(), PdfStandardFont(PdfFontFamily.helvetica, 12),format: PdfStringFormat(alignment: PdfTextAlignment.center),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)), bounds: const Rect.fromLTWH(100, 0, 0, 0));
    List<int> bytes = await document.save();
    document.dispose();
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    File file = File('$path$pdfName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path$pdfName');
  }


  ListView _buildListView(){
    return ListView.builder(
      itemCount: _allMeals.length,
      itemBuilder: (context, int index) {
        return ListTile(
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(_allEmails[index]), Text(_allDates[index])]),
          subtitle: Text(_allMeals[index]),
        );
      },
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
            SingleChildScrollView(
              child: SizedBox(
                height: 300,
                child: _buildListView(),
              ),
            ),
            ElevatedButton(onPressed: _createPDF, child: Text(AppLocale.exportPdfButton.getString(context))),
          ],
        ),
      ),
    );
  }
}

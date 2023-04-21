import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:l8_food/helpers/language_helper.dart';
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
  late String firstDate;
  late String lastDate;
  final String pdfName = '/Output.pdf';
  final String dateFormatString = 'EEEE';

  @override
  void initState() {
    _getMeals();
    super.initState();
  }

  Future<void> _getMeals() async {
    firstDate = _convertDateTime().first;
    lastDate = _convertDateTime().last;
    //TODO ovo u servis, izbaci then, koristi await
    await FirebaseFirestore.instance
        .collection('orders')
        .where('date', whereIn: _convertDateTime())
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          _allMeals.add('${docSnapshot.data().values.last}');
          _allDates.add(docSnapshot.data().values.first);
          _allEmails.add(docSnapshot.data().values.elementAt(4));
        }
      },
    );
    setState(() {});
  }

  List<String> _convertDateTime() {
    List<String> days = [];
    for (var day in _generateDate(5)) {
      days.add('${DateFormat(dateFormatString).format(day)},${day.day}.${day.month}.${day.year}');
    }
    return days;
  }

  List<DateTime> _generateDate(int count) {
    int weekends = 0;
    return List.generate(
      count,
      (index) {
        DateTime tempDate =
            DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: index + weekends));
        if (tempDate.weekday > 5) {
          int offset = 7 - tempDate.weekday + 1;
          tempDate = tempDate.add(Duration(days: offset));
          weekends += offset;
        }
        return tempDate;
      },
    );
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

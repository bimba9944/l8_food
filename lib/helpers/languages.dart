import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:l8_food/helpers/i18n/serbian.dart';
import 'package:l8_food/models/language.dart';

class Languages{

  static Locale defaultLanguageLocale = const Locale('sr');
  static String defaultLanguageCode = 'sr';
  static String defaultLanguageName = 'Serbian';

  static List<Language> languages = [
    Language(languageName: 'Serbian', languageCode: 'sr'),
  ];

  static List<MapLocale> mapOfLanguages = [
     const MapLocale('sr', Serbian.SR),
  ];

}
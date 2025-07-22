import 'package:flutter/material.dart';

class S {
  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();
  
  static const List<Locale> supportedLocales = [
    Locale.fromSubtags(languageCode: 'en'),
    Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
  ];

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S) ?? S();
  }

  String get pause_resume => 'PAUSE/RESUME';
  String get reset => 'RESET';
  String get sounds => 'SOUNDS';
  String get points => 'Points';
  String get cleans => 'Cleans';
  String get level => 'Level';
  String get next => 'Next';
  String get reward => 'Reward';
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<S> load(Locale locale) async {
    return S();
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}

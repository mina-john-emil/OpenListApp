// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'openlist_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class OpenListLocalizationsZh extends OpenListLocalizations {
  OpenListLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get app_title => 'AListWeb';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class OpenListLocalizationsZhCn extends OpenListLocalizationsZh {
  OpenListLocalizationsZhCn() : super('zh_CN');

  @override
  String get app_title => 'AListWeb';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class OpenListLocalizationsZhHans extends OpenListLocalizationsZh {
  OpenListLocalizationsZhHans() : super('zh_Hans');

  @override
  String get app_title => 'AListWeb';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class OpenListLocalizationsZhHant extends OpenListLocalizationsZh {
  OpenListLocalizationsZhHant() : super('zh_Hant');

  @override
  String get app_title => 'AListWeb';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class OpenListLocalizationsZhTw extends OpenListLocalizationsZh {
  OpenListLocalizationsZhTw() : super('zh_TW');

  @override
  String get app_title => 'AListWeb';
}

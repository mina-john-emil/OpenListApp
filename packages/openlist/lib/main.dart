import 'dart:io';
import 'dart:isolate';

import 'package:openlist/init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:openlist_native_ui/l10n/generated/openlist_native_ui_localizations.dart';
import 'package:openlist_web_ui/l10n/generated/openlist_web_ui_localizations.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'l10n/generated/openlist_localizations.dart';
import 'package:openlist_global/openlist_global.dart';
import 'package:openlist_web_ui/pages/login.dart' as openlist_web_ui;
import 'package:openlist_native_ui/pages/login.dart' as openlist_native_ui;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    await windowManager.ensureInitialized();
    windowManager.addListener(MyWindowListener());
  }
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CustomTheme()),
      ],
      child: const MyApp()
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenList',
      // themeMode: ThemeMode.system,
      theme: CustomThemes.light,
      darkTheme: CustomThemes.dark,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        OpenListLocalizations.delegate,
        OpenListWebUiLocalizations.delegate,
        OpenlistNativeUiLocalizations.delegate,
      ],
      supportedLocales: OpenListLocalizations.supportedLocales,
      localeListResolutionCallback: (locales, supportedLocales) {
        print("locales:$locales");
        return;
      },
      // home: const WebScreen(),
      // home: Platform.isMacOS?SplashImagePage():WebScreen(),
      // home: HomePage(),
      // home: (Platform.isIOS || Platform.isMacOS)?openlist_web_ui.LoginPage():openlist_native_ui.LoginPage(),
      // home: openlist_web_ui.LoginPage(),
      home: openlist_native_ui.LoginPage(),
    );
  }
}


class MyWindowListener extends WindowListener {
  @override
  void onWindowClose() {
    // 处理窗口关闭事件
    print("onWindowClose");
    exit(0);
  }

  @override
  void onWindowMaximize() {
    // 处理窗口最大化事件
    print("onWindowMaximize");
  }
}

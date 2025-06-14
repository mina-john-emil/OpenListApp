import 'dart:async';
import 'dart:io';

import 'package:openlist_native_ui/pages/storages/StoragesPage.dart';
import 'package:openlist_native_ui/pages/tasks/TasksPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../l10n/generated/openlist_native_ui_localizations.dart';
import 'files/FileManagerPage.dart';
import 'files/FilesWebPage.dart';
import 'me/profilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final Color _activeColor = Colors.orange;
  int _currentIndex = 0;
  Timer? _timer;
  SharedPreferences? prefs;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // flutter: AppLifecycleState.paused
    // flutter: AppLifecycleState.inactive
    // flutter: AppLifecycleState.resumed
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        print("AppLifecycleState.inactive");
        // showToast( "程序状态：${state.toString()}");
        // if (Platform.isIOS) {
        //   // _timer = Timer.periodic(Duration(seconds: 10), (timer) {
        //   //   exit(0);
        //   // });
        //   exit(0);
        // }
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        print("AppLifecycleState.resumed");
        // TODO
        // waitHttpPong().then((ret) async {
        //   if (ret == "restarted") {
        //     Directory appDir = await  getApplicationDocumentsDirectory();
        //     await setConfigData(appDir.path);
        //     await initAList();
        //     await startAList();
        //   }
        //   setState(() {});
        // });
        // showToast( "程序状态：${state.toString()}");
        if (_timer != null) {
          _timer!.cancel();
        }
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        print("AppLifecycleState.paused");
        // showToast( "程序状态：${state.toString()}");
        if (Platform.isIOS) {
          // _timer = Timer.periodic(Duration(seconds: 10), (timer) {
          //   exit(0);
          // });
          // exit(0);
        }
        break;
      case AppLifecycleState.detached: // APP结束时调用
        // showToast( "程序状态：${state.toString()}");
        print("AppLifecycleState.detached");
        exit(1);
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initSharedPreferences();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text(OpenLocalizations.of(context).app_title),),
        key: _scaffoldKey,
        // drawer: DrawerUI(),
        body: _buildBody(_currentIndex),
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        // floatingActionButton: _build_peedDial(),
        bottomNavigationBar: _buildBottomNavigationBar());
  }

//通过index判断展现的类型
  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return StoragesPage(
          key: UniqueKey(),
        );
        break;
      // case 1:
      //   return TasksPage(
      //     key: UniqueKey(),
      //   );
      //   break;
      case 1:
        return FileManagerPage();
        // return FilesWebPage(
        //   key: UniqueKey(),
        // );
        break;
      case 2:
        // return UserInfoPage();
        return const ProfilePage();
        break;
    }
    return Text("");
  }

  void _changePage(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  List<BottomNavigationBarItem> getBottomNavItems(BuildContext context) {
    final List<BottomNavigationBarItem> bottomNavItems = [
      BottomNavigationBarItem(
          icon: const Icon(TDIcons.hard_disk_storage),
          label: OpenlistNativeUiLocalizations.of(context).storages),
      // BottomNavigationBarItem(
      //     icon: const Icon(TDIcons.task),
      //     label: OpenlistNativeUiLocalizations.of(context).tasks,
      BottomNavigationBarItem(
          icon: const Icon(TDIcons.file),
          label: OpenlistNativeUiLocalizations.of(context).files),
      BottomNavigationBarItem(
          icon: const Icon(TDIcons.user),
          label: OpenlistNativeUiLocalizations.of(context).me),
    ];
    return bottomNavItems;
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: getBottomNavItems(context),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        _changePage(index);
      },
    );
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }
}

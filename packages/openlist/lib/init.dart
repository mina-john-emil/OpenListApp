import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaguar/jaguar.dart' as jaguar;
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart' as jaguar_flutter_asset;
import 'package:openlist_background_service/openlist_background_service.dart'
as openlist_background_service;
import 'package:openlist_api/openlist_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/config.dart';

List<Map<String, bool>>? initList;
// final APIBaseUrl = "http://localhost:15244";
// final PasswordHasBeenSet = "PasswordHasBeenSet";

Future<void> init() async {
  Directory appDir = await  getApplicationDocumentsDirectory();
  print("appDir.path:${appDir.path}");
  var backgrounService = BackgrounService(AListWebAPIBaseUrl);
  await initBackgroundService().then((_) async {
    await backgrounService.waitHttpPong();
    await backgrounService.setConfigData(appDir.path);
    // await Future.delayed(Duration(milliseconds: 50));
    await backgrounService.initAList();
    await backgrounService.startAList();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // 换另一个标志，只有用户设置过的才不重置密码，因为不卸载安装新的开发版密码不正确
    // if (!prefs.containsKey(PasswordHasBeenSet)) {
    //   await setAdminPassword("admin");
    // }
    await backgrounService.setAdminPassword("admin");
  });
}

void run(dynamic) async {
  openlist_background_service.run();
}

Future<void> initBackgroundService() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setBool("foreground", true);
  await Isolate.spawn(run, null);
  // await Isolate.run(() => run(null));
}

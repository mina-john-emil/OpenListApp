// TODO: Put public facing types in this file.

import 'dart:convert';

import 'package:openlist_api/src/utils/getDIO.dart';

/// Checks if you are awesome. Spoiler: you are.
class Storage {
  late String baseUrl;
  late String token;

  Storage(this.baseUrl, this.token);

  Future<Map> getAllStorage() async {
    // 获取支持的驱动
    final dio = getDIOByToken(baseUrl, token);
    String reqUri = "/api/admin/storage/list";
    try {
      final response = await dio.getUri(Uri.parse(reqUri));
      if (response.statusCode == 200 && response.data["code"] == 200) {
        //  登录成功
        Map<String, dynamic> data = response.data;
        // print(data["data"]);
        return data;
      } else {
        return {};
      }
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  Future<Map> disableEnableStorageById(String op, int id) async {
    // op = disable, enable
    // 获取支持的驱动
    final dio = getDIOByToken(baseUrl, token);
    String reqUri = "/api/admin/storage/$op?id=$id";
    try {
      // print(id);
      final response = await dio.postUri(Uri.parse(reqUri));
      // print(response);
      if (response.statusCode == 200 && response.data["code"] == 200) {
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  Future<Map> deleteStorageById(int id) async {
    // 获取支持的驱动
    final dio = getDIOByToken(baseUrl, token);
    String reqUri = "/api/admin/storage/delete?id=$id";
    try {
      // print(id);
      final response = await dio.postUri(Uri.parse(reqUri));
      // print(response);
      if (response.statusCode == 200 && response.data["code"] == 200) {
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  Future<Map> createOneStorage(Map addConfig, Map additionalConfig) async {
    addConfig["addition"] = jsonEncode(additionalConfig);
    print(jsonEncode(addConfig));
    // 获取支持的驱动
    final dio = getDIOByToken(baseUrl, token);
    String reqUri = "/api/admin/storage/create";
    try {
      final response = await dio.postUri(Uri.parse(reqUri), data: addConfig);
      // print(response);
      if (response.statusCode == 200 && response.data["code"] == 200) {
        //  登录成功
        Map<String, dynamic> data = response.data;
        // print(data["data"]);
        return data;
      } else {
        //  登录失败
        print(response.data);
        return {};
      }
    } catch (e) {
      //  登录失败
      print(e.toString());
      return {};
    }
  }

  Future<Map> getDriverList() async {
    // 获取支持的驱动
    final dio = getDIOByToken(baseUrl, token);
    String reqUri = "/api/admin/driver/list";
    try {
      final response = await dio.getUri(Uri.parse(reqUri));
      if (response.statusCode == 200 && response.data["code"] == 200) {
        //  登录成功
        Map<String, dynamic> data = response.data;
        // print(data["data"]);
        return data;
      } else {
        return {};
      }
    } catch (e) {
      print(e.toString());
      return {};
    }
  }
}

// TODO: Put public facing types in this file.

import 'package:dio/dio.dart';

import '../../utils/getDIO.dart';

/// Checks if you are awesome. Spoiler: you are.
class BackgrounService {
  late String baseUrl;

  BackgrounService(this.baseUrl);

  Future<void> setConfigData(String path) async {
    final dio = getDIO(baseUrl);
    String reqUri = "/set-config-data";
    final response = await dio.getUri(
      Uri(path: reqUri, queryParameters: {"path": path}),
    );
    if (response.statusCode == 200) {
      print("setConfigData:${path},ok");
    } else {
      print("setConfigData:${path},failed");
    }
  }

  Future<void> initAList() async {
    final dio = getDIO(baseUrl);
    String reqUri = "/init";
    final response = await dio.getUri(Uri.parse(reqUri));
    if (response.statusCode == 200) {
      print("initAList,ok");
    } else {
      print("initAList,failed");
    }
  }

  Future<void> startAList() async {
    final dio = getDIO(baseUrl);
    String reqUri = "/start";
    final response = await dio.getUri(Uri.parse(reqUri));
    if (response.statusCode == 200) {
      print("startAList,ok");
    } else {
      print("startAList,failed");
    }
  }

  Future<void> setAdminPassword(String password) async {
    final dio = getDIO(baseUrl);
    String reqUri = "/set-admin-password";
    final response = await dio.getUri(
      Uri(path: reqUri, queryParameters: {"password": password}),
    );
    if (response.statusCode == 200) {
      print("setAdminPassword:${password},ok");
      print(response.data);
    } else {
      print("setAdminPassword:${password},failed");
    }
  }

  Future<String> waitHttpPong() async {
    // 获取支持的驱动
    // alive,restarted
    String ret = "alive";
    final dio = getDIO(baseUrl);
    String reqUri = "/ping";
    while (true) {
      try {
        final response = await dio.getUri(
          Uri.parse(reqUri),
          options: Options(
            sendTimeout: Duration(milliseconds: 100),
            receiveTimeout: Duration(milliseconds: 100),
          ),
        );
        if (response.statusCode == 200) {
          //  登录成功
          Map<String, dynamic> data = response.data;
          print(data["data"]);
          return ret;
        } else {
          //  登录失败
          print("ping failed");
          return ret;
        }
      } catch (e) {
        //  登录失败
        print(e.toString());
        ret = "restarted";
      }
    }
  }
}

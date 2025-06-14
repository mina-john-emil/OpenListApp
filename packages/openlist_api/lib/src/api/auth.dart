// TODO: Put public facing types in this file.

import 'package:dio/dio.dart';
import 'package:openlist_api/src/api/file.dart';
import 'package:openlist_api/src/api/public.dart';
import 'package:openlist_api/src/api/setting.dart';
import 'package:openlist_api/src/api/storage.dart';
import 'package:openlist_api/src/api/task.dart';

import '../config/config.dart';

/// Checks if you are awesome. Spoiler: you are.
class Auth {
  late String baseUrl;
  late String username;
  late String password;

  late String token;

  Auth(this.baseUrl, this.username, this.password);

  Future<String> getToken() async {
    final dio = Dio(BaseOptions(baseUrl: AListAPIBaseUrl));
    String reqUri = "/api/auth/login";
    // String reqUri = "/api/auth/login/hash";
    try {
      final response = await dio.postUri(
        Uri.parse(reqUri),
        data: {'username': username, 'password': password},
      );
      if (response.statusCode == 200 && response.data["code"] == 200) {
        //  登录成功
        Map<String, dynamic> data = response.data;
        print(data["data"]["token"]);
        token = data["data"]["token"];
        return token;
      } else {
        //  登录失败
        print(response.data);
        return "";
      }
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  Public get PublicApi {
    // check token
    return Public(baseUrl);
  }

  Storage get StorageApi {
    // check token
    return Storage(baseUrl, token);
  }

  Task get TaskApi {
    // check token
    return Task(baseUrl, token);
  }

  Setting get SettingApi {
    // check token
    return Setting(baseUrl, token);
  }

  File get FileApi {
    // check token
    return File(baseUrl, token);
  }
}

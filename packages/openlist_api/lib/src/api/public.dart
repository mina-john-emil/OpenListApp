// TODO: Put public facing types in this file.

import '../utils/getDIO.dart';

/// Checks if you are awesome. Spoiler: you are.
class Public {
  late String baseUrl;

  Public(this.baseUrl);

  Future<Map> getSettings() async {
    final dio = getDIO(baseUrl);
    String reqUri = "/api/public/settings";
    // String reqUri = "/api/auth/login/hash";
    try {
      final response = await dio.getUri(Uri.parse(reqUri));
      if (response.statusCode == 200 && response.data["code"] == 200) {
        //  登录成功
        Map<String, dynamic> data = response.data;
        print(data["data"]["token"]);
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

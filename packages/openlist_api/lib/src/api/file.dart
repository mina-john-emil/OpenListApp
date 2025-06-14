// TODO: Put public facing types in this file.

import '../utils/getDIO.dart';

/// Checks if you are awesome. Spoiler: you are.
class File {
  late String baseUrl;
  late String token;

  File(this.baseUrl, this.token);

  Future<String> getFsList(String path) async {
    final dio = getDIOByToken(baseUrl, token);
    String reqUri = "/api/fs/list";
    try {
      final response = await dio.postUri(
        Uri.parse(reqUri),
        data: {"path": path},
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

  deleteFile(String dir, List<String> names) async {
    // status: restart,stop
    try {
      final dio = getDIOByToken(baseUrl, token);
      String reqUri = "/api/fs/remove";
      final response = await dio.deleteUri(
        Uri.parse(reqUri),
        data: {
          // TODO
          "names": names,
          "dir": dir,
        },
      );
      if (response.statusCode == 200) {
        return;
      } else {
        return;
      }
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  Future<Map> getFileDirInfo(String path) async {
    // status: restart,stop
    try {
      final dio = getDIOByToken(baseUrl, token);
      String reqUri = "/api/fs/get";
      final response = await dio.postUri(
        Uri.parse(reqUri),
        data: {"path": path, "password": ""},
      );
      if (response.statusCode == 200) {
        return response.data["data"];
      } else {
        return {};
      }
    } catch (e) {
      print(e.toString());
      return {};
    }
  }
}

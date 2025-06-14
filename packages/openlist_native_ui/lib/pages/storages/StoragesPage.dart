import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../l10n/generated/openlist_native_ui_localizations.dart';
import '../../utils/getDIO.dart';
import '../../utils/toast.dart';
import 'AddStorage.dart';

class StoragesPage extends StatefulWidget {
  const StoragesPage({super.key});

  @override
  State<StoragesPage> createState() => _StoragesPageState();
}

class _StoragesPageState extends State<StoragesPage> {
  List<dynamic> storageList = [];

  @override
  void initState() {
    super.initState();
    _getAllStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(OpenlistNativeUiLocalizations.of(context).storages),
        actions: [
          // IconButton(onPressed: (){_changeDataPath();}, icon: Icon(Icons.file_copy_outlined)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 2.0,
        tooltip: OpenlistNativeUiLocalizations.of(context).addStorage,
        onPressed: () {
          _add_storage();
        },
        child: const Icon(Icons.add),
      ),
      body: _buildStorageList(),
    );
  }

  _add_storage() {
    showDialog(context: context, builder: (_) => AddStorageWidget()).then((v) {
      _getAllStorage().then((v) {
        setState(() {});
      });
    });
  }

  Future<void> _getAllStorage() async {
    // 获取支持的驱动
    final dio = getDIO();
    String reqUri = "/api/admin/storage/list";
    try {
      final response = await dio.getUri(Uri.parse(reqUri));
      if (response.statusCode == 200 && response.data["code"] == 200) {
        //  登录成功
        Map<String, dynamic> data = response.data;
        // print(data["data"]);
        setState(() {
          storageList = data["data"]["content"];
          // print(storageList);
        });
        return;
      } else {
        //  登录失败
        show_failed("_getAllStorage failed", context);
      }
    } catch (e) {
      //  登录失败
      show_failed("_getAllStorage failed:${e.toString()}", context);
      print(e.toString());
      return;
    }
  }

  Widget _buildStorageList() {
    List<Widget> list = [];
    for (var storage in storageList) {
      list.add(
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min, // 使卡片的高度适应内容
            children: <Widget>[
              ListTile(
                leading: Column(children: [Icon(Icons.storage, size: 75),Text(storage["remark"])],), // 卡片左侧的图标
                title: Row(
                  children: [
                    Text(storage["mount_path"]),
                    SizedBox(width: 10),
                    TDSelectTag(
                      storage["driver"],
                      theme: TDTagTheme.primary,
                      isLight: false,
                      isOutline: true,
                      isSelected: true,
                    ),
                  ],
                ), // 卡片标题
                subtitle: Container(
                  padding: const EdgeInsets.only(left: 5, top: 16, bottom: 16),
                  child: Row(
                    children: [
                      Text(OpenlistNativeUiLocalizations.of(context).status),
                      SizedBox(width: 10),
                      TDSelectTag(
                        storage["status"],
                        theme:
                            storage["status"] == "work"
                                ? TDTagTheme.success
                                : TDTagTheme.primary,
                        isLight: false,
                        isOutline: true,
                        isSelected: true,
                      ),
                    ],
                  ),
                ), // 卡片副标题
              ),
              OverflowBar(
                children: <Widget>[
                  storage["disabled"]
                      ? TextButton(
                        child: Text(OpenlistNativeUiLocalizations.of(context).enable), // 按钮1
                        onPressed: () {
                          // 根据现在状态进行启用和禁止
                          _disableEnableStorageById("enable", storage["id"]);
                        }, // 按钮1的点击事件
                      )
                      : TextButton(
                        child: Text(OpenlistNativeUiLocalizations.of(context).disable), // 按钮1
                        onPressed: () {
                          // 根据现在状态进行启用和禁止
                          _disableEnableStorageById("disable", storage["id"]);
                        }, // 按钮1的点击事件
                      ),
                  TextButton(
                    child: Text(OpenlistNativeUiLocalizations.of(context).delete), // 按钮2
                    onPressed: () {
                      _deleteStorageById(storage["id"]);
                    }, // 按钮2的点击事件
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    ListView listView = ListView(children: list);
    return listView;
  }

  Future<void> _disableEnableStorageById(String op, int id) async {
    // op = disable, enable
    // 获取支持的驱动
    final dio = getDIO();
    String reqUri = "/api/admin/storage/$op?id=$id";
    try {
      // print(id);
      final response = await dio.postUri(Uri.parse(reqUri));
      // print(response);
      if (response.statusCode == 200 && response.data["code"] == 200) {
        show_success("change status success!", context);
        _getAllStorage();
        return;
      } else {
        //  登录失败
        show_failed("change status failed", context);
      }
    } catch (e) {
      //  登录失败
      show_failed("change status failed:${e.toString()}", context);
      print(e.toString());
      return;
    }
  }

  Future<void> _deleteStorageById(int id) async {
    // 获取支持的驱动
    final dio = getDIO();
    String reqUri = "/api/admin/storage/delete?id=$id";
    try {
      // print(id);
      final response = await dio.postUri(Uri.parse(reqUri));
      // print(response);
      if (response.statusCode == 200 && response.data["code"] == 200) {
        show_success("delete success!", context);
        _getAllStorage();
        return;
      } else {
        //  登录失败
        show_failed("delete failed", context);
      }
    } catch (e) {
      //  登录失败
      show_failed("delete failed:${e.toString()}", context);
      print(e.toString());
      return;
    }
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../l10n/generated/openlist_native_ui_localizations.dart';
import '../../utils/getDIO.dart';
import '../../utils/toast.dart';

class AddStorageWidget extends StatefulWidget {
  const AddStorageWidget({super.key});

  @override
  State<AddStorageWidget> createState() => _AddStorageWidgetState();
}

class _AddStorageWidgetState extends State<AddStorageWidget> {
  String? selectedDriverType;
  Map<String, dynamic> driverTypes = {};
  Map<String, dynamic> addConfig = {};
  Map<String, dynamic> additionalConfig = {};

  @override
  void initState() {
    super.initState();
    getDriverList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(OpenlistNativeUiLocalizations.of(context).addStorage),
      content: SizedBox(
        width: 250,
        height: 330,
        child: Column(
          children: <Widget>[
            // 选择驱动
            DropdownButtonFormField<String>(
              value: selectedDriverType,
              onChanged: (String? newValue) {
                setState(() {
                  addConfig.clear();
                  additionalConfig.clear();
                  selectedDriverType = newValue!;
                  addConfig["driver"] = newValue;
                  // TODO 显示对应选项
                });
              },
              items:
                  driverTypes.keys.toList().map<DropdownMenuItem<String>>((
                    String driverTypeName,
                  ) {
                    return DropdownMenuItem<String>(
                      value: driverTypeName,
                      child: Text(driverTypeName),
                    );
                  }).toList(),
              decoration: InputDecoration(labelText: "choose an driver"),
            ),
            // TODO 对应驱动的配置表单
            SizedBox(
              height: 250,
              width: 300,
              child: ListView(children: _buildConfigForm()),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(OpenlistNativeUiLocalizations.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(OpenlistNativeUiLocalizations.of(context).add),
          onPressed: () async {
            await createOneStorage();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  createOneStorage() async {
    addConfig["addition"] = jsonEncode(additionalConfig);
    print(jsonEncode(addConfig));
    // 获取支持的驱动
    final dio = getDIO();
    String reqUri = "/api/admin/storage/create";
    try {
      final response = await dio.postUri(Uri.parse(reqUri), data: addConfig);
      // print(response);
      if (response.statusCode == 200 && response.data["code"] == 200) {
        //  登录成功
        Map<String, dynamic> data = response.data;
        // print(data["data"]);
        setState(() {
          // TODO 更新storage列表
          // driverTypes = data["data"];
        });
        return;
      } else {
        //  登录失败
        print(response.data);
        show_failed("createOneStorage failed", context);
      }
    } catch (e) {
      //  登录失败
      show_failed("createOneStorage failed:${e.toString()}", context);
      print(e.toString());
      return;
    }
  }

  List<Widget> _buildConfigForm() {
    List<Widget> formList = [];
    if (selectedDriverType == null || selectedDriverType!.isEmpty) {
      return formList;
    }
    var driverFormConfig = driverTypes[selectedDriverType];
    // string：TDInput，bool：TDSwitch，select：TDPicker，text：TDTextarea
    driverFormConfig["common"].forEach((config) {
      // 创建一个默认的配置
      addConfig[config["name"]] =
          addConfig.containsKey(config["name"])
              ? addConfig[config["name"]]
              : getValueWithType(config["default"], config["type"]);
      switch (config["type"]) {
        case "string":
        case "text":
          TextEditingController controller = TextEditingController.fromValue(
            TextEditingValue(text: addConfig[config["name"]]),
          );
          formList.add(
            TDInput(
              leftLabel: config["name"],
              required: config["required"],
              controller: controller,
              backgroundColor: Colors.white,
              hintText: config["help"],
              leftInfoWidth: 5,
              leftLabelSpace: 5,
              onChanged: (text) {
                addConfig[config["name"]] = getValueWithType(
                  text,
                  config["type"],
                );
              },
            ),
          );
          break;
        // case "number":
        //   return value.isEmpty?0:num.parse(value);
        //   break;
        case "bool":
          formList.add(
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 5, top: 16, bottom: 16),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(config["name"]),
                      config["required"]
                          ? Text("*", style: TextStyle(color: Colors.red))
                          : Text(""),
                    ],
                  ),
                  SizedBox(width: 6),
                  Switch(
                    onChanged: (_) {
                      setState(() {
                        addConfig[config["name"]] = !addConfig[config["name"]];
                      });
                    },
                    value: addConfig[config["name"]],
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ],
              ),
            ),
          );
          break;
        case "select":
          List<String> data = config["options"].split(",");
          formList.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(children: [Text(config["name"]),config["required"]?Text("*",style: TextStyle(color: Colors.red),):Text("")],),
                GestureDetector(
                  onTap: () {
                    TDPicker.showMultiPicker(
                      context,
                      title: config["name"],
                      onConfirm: (selectedValue) {
                        setState(() {
                          addConfig[config["name"]] =
                              '${data[selectedValue[0]]}';
                        });
                        Navigator.of(context).pop();
                      },
                      data: [data],
                      leftText: config["name"],
                    );
                  },
                  child: buildSelectRow(
                    context,
                    addConfig[config["name"]],
                    config["name"],
                  ),
                ),
              ],
            ),
          );
          break;
        // case "float":
        //   return value.isEmpty?0:double.parse(value);
        //   break;
      }
    });
    formList.add(Divider());
    driverFormConfig["additional"].forEach((config) {
      additionalConfig[config["name"]] =
          additionalConfig.containsKey(config["name"])
              ? additionalConfig[config["name"]]
              : getValueWithType(config["default"], config["type"]);
      switch (config["type"]) {
        case "string":
        case "text":
          TextEditingController controller = TextEditingController.fromValue(
            TextEditingValue(text: additionalConfig[config["name"]]),
          );
          formList.add(
            TDInput(
              leftLabel: config["name"],
              required: config["required"],
              controller: controller,
              backgroundColor: Colors.white,
              hintText: config["help"],
              leftInfoWidth: 5,
              leftLabelSpace: 5,
              onChanged: (text) {
                additionalConfig[config["name"]] = getValueWithType(
                  text,
                  config["type"],
                );
              },
            ),
          );
          break;
        // case "number":
        //   return value.isEmpty?0:num.parse(value);
        //   break;
        case "bool":
          formList.add(
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 5, top: 16, bottom: 16),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(config["name"]),
                      config["required"]
                          ? Text("*", style: TextStyle(color: Colors.red))
                          : Text(""),
                    ],
                  ),
                  SizedBox(width: 6),
                  Switch(
                    onChanged: (_) {
                      setState(() {
                        additionalConfig[config["name"]] =
                            !additionalConfig[config["name"]];
                      });
                    },
                    value: additionalConfig[config["name"]],
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ],
              ),
            ),
          );
          break;
        case "select":
          List<String> data = config["options"].split(",");
          formList.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(children: [Text(config["name"]),config["required"]?Text("*",style: TextStyle(color: Colors.red),):Text("")],),
                GestureDetector(
                  onTap: () {
                    TDPicker.showMultiPicker(
                      context,
                      title: config["name"],
                      onConfirm: (selectedValue) {
                        setState(() {
                          additionalConfig[config["name"]] =
                              '${data[selectedValue[0]]}';
                        });
                        Navigator.of(context).pop();
                      },
                      data: [data],
                      leftText: config["name"],
                    );
                  },
                  child: buildSelectRow(
                    context,
                    additionalConfig[config["name"]],
                    config["name"],
                  ),
                ),
              ],
            ),
          );
          break;
        // case "float":
        //   return value.isEmpty?0:double.parse(value);
        //   break;
      }
    });
    // driverFormConfig["config"].forEach((config){
    //
    // });
    return formList;
  }

  getValueWithType(String value, String type) {
    switch (type) {
      case "string":
        return value;
        break;
      case "number":
        return value.isEmpty ? 0 : num.parse(value);
        break;
      case "bool":
        return value.isEmpty ? false : bool.parse(value);
        break;
      case "text":
        return value;
        break;
      case "select":
        return value;
        break;
      case "float":
        return value.isEmpty ? 0 : double.parse(value);
        break;
    }
  }

  // TODO 从mdns获取所有主机地址，并添加“手动填写”， “127.0.0.1”
  Future getDriverList() async {
    // 获取支持的驱动
    final dio = getDIO();
    String reqUri = "/api/admin/driver/list";
    try {
      final response = await dio.getUri(Uri.parse(reqUri));
      if (response.statusCode == 200 && response.data["code"] == 200) {
        //  登录成功
        Map<String, dynamic> data = response.data;
        // print(data["data"]);
        setState(() {
          driverTypes = data["data"];
        });
        return;
      } else {
        //  登录失败
        show_failed("getDriverList failed", context);
      }
    } catch (e) {
      //  登录失败
      show_failed("getDriverList failed:${e.toString()}", context);
      print(e.toString());
      return;
    }
  }

  Widget buildSelectRow(BuildContext context, String output, String title) {
    return Container(
      color: TDTheme.of(context).whiteColor1,
      height: 56,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 16, bottom: 16),
                child: TDText(title, font: TDTheme.of(context).fontBodyLarge),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TDText(
                          output,
                          font: TDTheme.of(context).fontBodyLarge,
                          textColor: TDTheme.of(
                            context,
                          ).fontGyColor3.withOpacity(0.4),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Icon(
                          TDIcons.chevron_right,
                          color: TDTheme.of(
                            context,
                          ).fontGyColor3.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const TDDivider(margin: EdgeInsets.only(left: 16)),
        ],
      ),
    );
  }
}

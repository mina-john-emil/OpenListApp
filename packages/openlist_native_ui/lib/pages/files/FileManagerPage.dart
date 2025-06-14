import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:path/path.dart' as p;
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../config/config.dart';
import '../../l10n/generated/openlist_native_ui_localizations.dart';
import '../../utils/getDIO.dart';
import '../../utils/toast.dart';
import '../../widgets/goToUrl.dart';
import '../common/videp_player.dart';
import '../web/web.dart';

class FileManagerPage extends StatefulWidget {
  const FileManagerPage({Key? key}) : super(key: key);

  @override
  State<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  // 根据页面宽度确定一行展示几个文件(夹)
  static const _num_one_row = 3;
  static const _picture_ext_names = [
    "bmp",
    "jpg",
    "png",
    "jpeg",
    "ico",
    "webp",
    "gif",
  ];
  static const _video_ext_names = ["mp4", "avi", "flv", "rmvb"];
  static const _music_ext_names = [
    "mp3",
    "wav",
    "aac",
    "m4a",
    "flac",
    "ogg",
    "wma",
    "aiff"
        "aif",
    "amr",
    "m4r",
  ];
  String _current_path = "/";

  Widget _files_list_widget = Column(
    children: [
      TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.point,
        iconColor: Colors.grey,
      ),
      Text("Please add storage first"),
    ],
  );

  @override
  void initState() {
    _displayRootPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(OpenlistNativeUiLocalizations.of(context).files),
        // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.upload))],
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       _displayRootPath();
        //     },
        //     icon: Icon(Icons.home),
        //   ),
        // ],
      ),
      body: _buildPaginationSideBar(context),
    );
  }

  Widget _buildPaginationSideBar(BuildContext context) {
    var demoHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: demoHeight,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: getPathFileList(),
            ),
          ),
        ),
      ],
    );
  }

  void _displayRootPath() {
    // 显示文件列表
    displayImageList("/");
  }

  // 文件夹内文件列表页面
  Widget getPathFileList() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
            // TODO 点击跳转
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _displayRootPath();
                  },
                  icon: Icon(Icons.home),
                ),
                BreadCrumb.builder(
                  itemCount: _current_path.split(RegExp(r'[/]')).length,
                  builder: (index) {
                    return BreadCrumbItem(
                      content: Text(_current_path.split(RegExp(r'[/]'))[index]),
                      onTap: () {
                        var pathList = ["/"];
                        pathList.addAll(
                          _current_path
                              .split(RegExp(r'[/]'))
                              .getRange(0, index + 1),
                        );
                        var _path = p.joinAll(pathList);
                        // print("_path:$_path");
                        displayImageList(_path);
                      },
                    );
                  },
                  divider: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // displayImageList(path)
          _files_list_widget,
        ],
      ),
    );
  }

  // 文件列表
  void displayImageList(String path) async {
    _current_path = path;
    // TODO 根据api获取文件(夹)列表
    final dio = getDIO();
    String reqUri = "/api/fs/list";
    try {
      final response = await dio.postUri(
        Uri.parse(reqUri),
        data: {"path": path},
      );
      // print(response);
      if (response.data["code"] == 200) {
        List<Widget> _row_list = [];
        // 一行
        List<Widget> _item_list = [];
        for (int i = 0; i < response.data["data"]["content"].length; i++) {
          if ((i + 1) % _num_one_row == 0) {
            _item_list.add(
              displayImageItem(
                p.join(
                  _current_path,
                  response.data["data"]["content"][i]["name"],
                ),
                response.data["data"]["content"][i]["name"],
                response.data["data"]["content"][i]["is_dir"],
                response.data["data"]["content"][i],
              ),
            );
            // 将所有行相加
            _row_list.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  _item_list.length,
                  (index) => _item_list[index],
                ),
              ),
            );
            _item_list.clear();
            _row_list.add(const SizedBox(height: 18));
          } else {
            _item_list.add(
              displayImageItem(
                p.join(
                  _current_path,
                  response.data["data"]["content"][i]["name"],
                ),
                response.data["data"]["content"][i]["name"],
                response.data["data"]["content"][i]["is_dir"],
                response.data["data"]["content"][i],
              ),
            );
            // 如果遍历完了那这里就得拼接
            if (i + 1 == response.data["data"]["content"].length) {
              // 填充空组件好让最后一行靠前排列
              for (
                int i = 0;
                i <
                    (_num_one_row -
                        (response.data["data"]["content"].length %
                            _num_one_row));
                i++
              ) {
                _item_list.add(_build_empty_placeholder());
              }
              // 将所有行相加
              _row_list.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    _item_list.length,
                    (index) => _item_list[index],
                  ),
                ),
              );
              _item_list.clear();
              _row_list.add(const SizedBox(height: 18));
            }
          }
        }
        setState(() {
          _files_list_widget = Column(children: _row_list);
        });
      }
      // else {
      //   show_failed("Access error:${response.data["message"]}", context);
      // }
    } catch (e) {
      show_failed(e.toString(), context);
    }
  }

  // 文件(夹)图标
  Widget displayImageItem(
    //   path是当前文件夹拼接此文件
    String path,
    name,
    bool is_folder,
    Map<String, dynamic> content,
  ) {
    // 获取文件夹、文件图标
    String ico_file_path = "";
    // 获取文件网络路径uri，目前主要是图片
    String _image_url = "";
    // String _image_url_thumbnail = "";
    if (is_folder) {
      // 是文件夹
      ico_file_path = "assets/files/folder.png";
    } else {
      if (path.indexOf(RegExp(r'[.]')) != -1 &&
          _picture_ext_names.contains(path.split(RegExp(r'[.]')).last)) {
        // 是图片
        ico_file_path = "assets/files/image.jpg";
      } else {
        // 是普通文件
        ico_file_path = "assets/files/file.png";
      }
    }
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            child: Image.asset(
              // TODO 显示图片预览缩略图、根据文件类型显示个性化文件图标
              ico_file_path,
              // package: "",
              width: 48,
              height: 48,
              // 确保路径正确且已在pubspec.yaml中声明
            ),
            onTap: () async {
              // TODO 如果pc则双击，如果移动端则单击
              if (is_folder) {
                // 如果是文件夹则进入文件夹
                displayImageList(path);
              } else {
                //TODO 下载或预览文件
                //  /api/fs/get
                var fileInfo = await _getFileDirInfo(path);
                // 预览文件,判断有扩展名
                // 通用的文件访问api，目前视频是使用这个
                var _file_web_url = "$AListAPIBaseUrl$path";
                var _file_url = fileInfo["raw_url"];
                if (path.contains(RegExp(r'[.]'))) {
                  var _ext_name = path.split(RegExp(r'[.]')).last;
                  if (_picture_ext_names.contains(_ext_name)) {
                    // 根据扩展名判断是图片，开始图片预览
                    // TODO 所有图片
                    var files = [_file_url];
                    TDImageViewer.showImageViewer(
                      context: context,
                      // 本文件夹所有图片列表，并定位到当前文件
                      images: files,
                      showIndex: true,
                      deleteBtn: true,
                      onDelete: (int index) {
                        _deleteFile(_current_path, [name]);
                      },
                    );
                  } else if (_video_ext_names.contains(_ext_name)) {
                    // 根据扩展名判断是视频，开始视频预览,如果是移动平台则使用内置平台，如果是pc平台则使用系统浏览器？
                    if (Platform.isWindows || Platform.isLinux) {
                      launchURL(_file_url);
                    } else {
                      // 使用内置播放器
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) {
                            return VideoPlayerPage(
                              key: UniqueKey(),
                              url: _file_url,
                            );
                          },
                        ),
                      );
                    }
                  } else if (_music_ext_names.contains(_ext_name)) {
                    // 播放音乐，原则上说应该将本文件夹所有音乐都加入播放列表
                    if (Platform.isWindows || Platform.isLinux) {
                      launchURL(_file_url);
                    } else {
                      // 使用内置播放器
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) {
                            return VideoPlayerPage(
                              key: UniqueKey(),
                              url: _file_url,
                            );
                          },
                        ),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (ctx) {
                      //       return WebScreen(startUrl: _file_web_url);
                      //     },
                      //   ),
                      // );
                    }
                  } else {
                    // TODO 未知的文件类型默认提示下载或其他方式
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (ctx) {
                    //       return WebScreen(startUrl: _file_web_url);
                    //     },
                    //   ),
                    // );
                  }
                }
              }
            },
            // TODO 长按或者右键显示菜单:下载，拷贝路径，重新命名，剪切，复制，删除
            onLongPress: () async {
              var fileInfo = await _getFileDirInfo(path);
              // 预览文件,判断有扩展名
              // 通用的文件访问api，目前视频是使用这个
              var _file_web_url = "$AListAPIBaseUrl$path";
              var _file_url = fileInfo["raw_url"];
              //   长按操作界面
              TDActionSheet(
                context,
                visible: true,
                description: "File Operation",
                items: [
                  TDActionSheetItem(
                    label: 'Delete',
                    icon: Icon(Icons.delete_forever, color: Colors.red),
                    disabled: false,
                  ),
                  // TDActionSheetItem(
                  //   label: 'Web Viewer',
                  //   icon: Icon(Icons.remove_red_eye, color: Colors.blue),
                  // ),
                  TDActionSheetItem(
                    label: 'Download',
                    icon: Icon(Icons.download, color: Colors.orange),
                  ),
                ],
                onSelected: (TDActionSheetItem item, int index) {
                  switch (index) {
                    case 0:
                      // 确认操作
                      _deleteFile(_current_path, [name]);
                      break;
                    // case 1:
                    //   // 确认操作
                    //   _webViewer(_file_web_url, context);
                    //   break;
                    case 1:
                      // 确认操作
                      _webViewer(_file_url, context);
                      break;
                  }
                },
              );
            },
          ),
          const SizedBox(height: 8),
          TDText('$name', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  _deleteFile(String dir, List<String> names) async {
    // status: restart,stop
    final dio = getDIO();
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
      show_success("Delete Success", context);
      displayImageList(_current_path);
    } else {
      show_failed("Delete Failed", context);
      displayImageList(_current_path);
    }
  }

  _webViewer(String url, BuildContext context) async {
    launchURL(url);
    return;
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (ctx) {
    //       return WebScreen(startUrl: url);
    //     },
    //   ),
    // );
  }

  _getFileDirInfo(String path) async {
    // status: restart,stop
    final dio = getDIO();
    String reqUri = "/api/fs/get";
    final response = await dio.postUri(
      Uri.parse(reqUri),
      data: {"path": path, "password": ""},
    );
    if (response.statusCode == 200) {
      return response.data["data"];
    } else {
      show_failed("Delete Failed", context);
    }
    return {};
  }

  Widget _build_empty_placeholder() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [SizedBox(width: 48, height: 48)],
      ),
    );
  }

  Widget _sizedContainer(Widget child) {
    return SizedBox(width: 48, height: 48, child: Center(child: child));
  }
}

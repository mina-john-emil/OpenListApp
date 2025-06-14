import 'package:openlist_web_ui/config/config.dart';
import 'package:openlist_web_ui/pages/web/web.dart';
import 'package:flutter/cupertino.dart';

class StoragesPage extends StatefulWidget {
  const StoragesPage({super.key});

  @override
  State<StoragesPage> createState() => _StoragesPageState();
}

class _StoragesPageState extends State<StoragesPage> {
  @override
  Widget build(BuildContext context) {
    return WebScreen(startUrl: "$AListAPIBaseUrl/@manage/storages");
  }
}

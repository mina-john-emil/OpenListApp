
import 'package:openlist_native_ui/config/global.dart';
import 'package:dio/dio.dart';

import '../config/config.dart';

Dio getDIO(){
  final dio = Dio(BaseOptions(baseUrl: AListAPIBaseUrl, headers: {
    "Authorization": token
  }));
  return dio;
}

Dio getAListWebPublicApiDIO(){
  final dio = Dio(BaseOptions(baseUrl: AListWebAPIBaseUrl));
  return dio;
}

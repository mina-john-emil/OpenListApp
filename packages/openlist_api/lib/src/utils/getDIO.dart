import 'package:dio/dio.dart';

Dio getDIOByToken(String baseUrl, tokenStr){
  final dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
    "Authorization": tokenStr
  }));
  return dio;
}

Dio getDIO(String baseUrl){
  final dio = Dio(BaseOptions(baseUrl: baseUrl));
  return dio;
}

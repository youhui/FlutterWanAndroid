import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class DioManager {
  Dio _dio;

  DioManager._internal() {
    _dio = new Dio();
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };
  }

  static DioManager shared = DioManager._internal();

  factory DioManager() => shared;

  get dio {
    return _dio;
  }
}

import 'package:dio/dio.dart';

class BasicAuth {
  final String user;
  final String pwd;
  BasicAuth({required this.user, required this.pwd});
}

class WebdavClient {
  final String url;
  final BasicAuth auth;
  final Dio _dio = Dio();

  WebdavClient({required this.url, required this.auth});

  void setHttpClientAdapter(HttpClientAdapter adapter) {
    _dio.httpClientAdapter = adapter;
  }

  void setHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  void setConnectTimeout(dynamic timeout) {
    if (timeout is int) {
      _dio.options.connectTimeout = Duration(milliseconds: timeout);
    } else if (timeout is Duration) {
      _dio.options.connectTimeout = timeout;
    }
  }

  Future<void> ping() async {}
  Future<void> mkdir(String path) async {}
  Future<void> write(String path, dynamic data) async {}
  Future<void> writeFile(String path, dynamic data) async {}
  Future<List<int>> read(String path) async => [];
  Future<String> read2(String path) async => "";
  Future<List<int>> readFile(String path, [dynamic opt]) async => [];
  Future<List<dynamic>> ls(String path) async => [];
  Future<List<dynamic>> readDir(String path) async => [];
  Future<void> delete(String path) async {}
  Future<void> remove(String path) async {}
}

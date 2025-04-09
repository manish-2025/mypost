import 'package:dio/dio.dart';
import 'package:mypost/common/api_constants.dart';

class Api {
  final Dio _dio = Dio();

  // ignore: non_constant_identifier_names
  API() {
    print("object => ApiConstants.baseUrl ${ApiConstants.baseUrl}");
    _dio.options.baseUrl = ApiConstants.baseUrl;
  }

  Dio get sendRequest => _dio;
}

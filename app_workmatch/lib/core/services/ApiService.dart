import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = "https://workmatch-backend-d6f9.onrender.com";

  late Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );
  }
}

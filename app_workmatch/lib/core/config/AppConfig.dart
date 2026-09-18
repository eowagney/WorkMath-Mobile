import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppConfig {
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ??
      'https://workmatch-backend-d6f9.onrender.com';

  static Duration get apiTimeout => Duration(
        seconds: int.tryParse(dotenv.env['API_TIMEOUT_SECONDS'] ?? '15') ?? 15,
      );
}

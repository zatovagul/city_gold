import 'package:flutter_dotenv/flutter_dotenv.dart';

Uri pathBulderAPI(String endpoint,[Map<String, dynamic>? queryParameters]) {
  return Uri.https(dotenv.env['DOMAIN_BACKEND']!, endpoint, queryParameters);
}
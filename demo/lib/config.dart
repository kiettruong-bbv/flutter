import 'package:flutter_config/flutter_config.dart';

enum Config { ENV, GOOGLE_API_KEY }

extension ConfigEx on Config {
  String get() {
    return FlutterConfig.get(name);
  }
}

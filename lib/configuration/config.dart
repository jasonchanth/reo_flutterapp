import 'package:flutter/cupertino.dart';

import '../PollingStationListPage.dart';

class Config {
  static const String apiUrl = 'http://192.168.70.137:8080/';
  static const int maxRetries = 3;
  static const bool enableLogging = true;
  static Map<String, Widget> pageRoutes = {
    'PollingStationListPage': PollingStationListPage(),
    // 其他页面与对应的 Widget
  };
}
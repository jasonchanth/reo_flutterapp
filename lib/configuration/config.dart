import 'package:flutter/cupertino.dart';
import 'package:helpdesk_demo/helpdesk/helpdesk_main.dart';

import '../PollingStationListPage.dart';
import '../helpdesk/ticket_list.dart';
import '../pollingStation/pollingStation_main.dart';

class Config {
  static const String apiUrl = 'http://192.168.70.137:8080/';
  static const int maxRetries = 3;
  static const bool enableLogging = true;
  static const Color appBarColor = CupertinoColors.activeGreen;
  static Map<String, Widget> pageRoutes = {

    'PollingStationMain': const PollingStationMain(),
    'PollingStationListPage': const PollingStationListPage(),
    'TicketListPage':const Helpdesk()
    // 其他页面与对应的 Widget
  };
}

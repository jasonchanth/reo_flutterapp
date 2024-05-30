import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_demo/helpdesk/helpdesk_main.dart';

import '../PollingStationListPage.dart';
import '../PollingStationScheduleListPage.dart';
import '../helpdesk/ticket_list.dart';
import '../pollingStation/pollingStation_main.dart';
import '../pollingStation/pollingStation_technicalPack.dart';

class Config {
  static const String apiUrl = 'http://192.168.70.137:8080/';
  static const int maxRetries = 3;
  static const bool enableLogging = true;
  static const Color appBarColor = Colors.lightBlue;
  static Map<String, Widget> pageRoutes = {

    'PollingStationMain': const PollingStationListPage(),
    'PollingStationScheduleList': const PollingStationScheduleListPage(),
    'PollingStationListPage': const PollingStationListPage(),
    'TicketListPage':const Helpdesk(),
    'PollingStationTechnicalPack': const PollingStationTechnicalPack(),
    // 其他页面与对应的 Widget
  };
}

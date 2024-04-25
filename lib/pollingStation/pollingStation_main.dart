import 'package:flutter/material.dart';
import 'package:helpdesk_demo/pollingStation/pollingStation_Info.dart';
import 'package:helpdesk_demo/pollingStation/pollingStation_documents.dart';
import 'package:helpdesk_demo/pollingStation/pollingStation_task.dart';
import 'package:helpdesk_demo/pollingStation/pollingStation_schedule.dart';

import '../configuration/config.dart';
import '../helpdesk/ticket_add.dart';
import '../helpdesk/ticket_list.dart';
import '../menu_list.dart';

class PollingStationMain extends StatefulWidget {
  const PollingStationMain({super.key});

  @override
  State<PollingStationMain> createState() => _PollingStationMainState();
}

class _PollingStationMainState extends State<PollingStationMain> {
  int currentPage = 0;
  List<Widget> page = [const TaskListPage(), PollingStationSchedule(),PollingStationDocument()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Polling Station"),
          backgroundColor: Config.appBarColor),
      drawer: menulist(),
      body: Column(
        children: [
          const PollingStationInfo(),
      Expanded(
          child:  page[currentPage],),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Task'),
          NavigationDestination(icon: Icon(Icons.schedule), label: 'Schedule'),
          NavigationDestination(icon: Icon(Icons.description), label: 'Document'),],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}

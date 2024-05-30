import 'package:flutter/material.dart';
import 'package:helpdesk_demo/api/MapUtils.dart';
import 'package:helpdesk_demo/pollingStation/pollingStation_Info.dart';
import 'package:helpdesk_demo/pollingStation/pollingStation_documents.dart';
import 'package:helpdesk_demo/pollingStation/pollingStation_task.dart';
import 'package:helpdesk_demo/pollingStation/pollingStation_schedule.dart';
import 'package:helpdesk_demo/pollingStation/pollingStation_technicalPack.dart';

import '../PollingStation.dart';
import '../configuration/config.dart';
import '../helpdesk/ticket_add.dart';
import '../helpdesk/ticket_list.dart';
import '../menu_list.dart';
import '../widgets/homePageM.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PollingStationMain extends StatefulWidget {
  //const PollingStationMain({super.key});
  final PollingStation pollingStation;
  final int initialPage;
  const PollingStationMain({Key? key, required this.pollingStation, this.initialPage = 0}) : super(key: key);


  @override
  State<PollingStationMain> createState() => _PollingStationMainState();
}

class _PollingStationMainState extends State<PollingStationMain> {
  int currentPage = 0;
  late PollingStation pollingStation;
  //List<Widget> page = [ TaskListPage(), const PollingStationSchedule(),const PollingStationDocument(),const PollingStationTechnicalPack()];
  late List<Widget> page;
  late String username = "";

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
    pollingStation = widget.pollingStation;
    page = [ TaskListPage(pollingStation: pollingStation),  PollingStationSchedule(pollingStation: pollingStation),const PollingStationDocument(),const PollingStationTechnicalPack()];


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Polling Station"),
          backgroundColor: Config.appBarColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              size: 40,
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePageM(userRole: 'admin')),
              );
            },
          )
        ],
      ),
      drawer: menulist(),

      body: Column(
        children: [
           PollingStationInfo(pollingStation: pollingStation),
      Expanded(
          child:  page[currentPage],),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Task'),
          NavigationDestination(icon: Icon(Icons.schedule), label: 'Schedule'),
          NavigationDestination(icon: Icon(Icons.description), label: 'Document'),
          //NavigationDestination(icon: Icon(Icons.gps_fixed), label: 'Location'),
          //NavigationDestination(icon: Icon(Icons.document_scanner), label: 'Reference Docs'),
          NavigationDestination(icon: Icon(Icons.edit_document), label: 'Technical Pack'),],
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

import 'package:flutter/material.dart';
import 'package:helpdesk_demo/helpdesk/ticket_add.dart';

import 'ticket_list.dart';
import '../menu_list.dart';

import '../configuration/config.dart';
class Helpdesk extends StatefulWidget {
  const Helpdesk ({Key? key}) : super(key: key);

  @override
  State<Helpdesk> createState() => _HelpdeskState();
}

class _HelpdeskState extends State<Helpdesk> {
  int currentPage = 0;
  List<Widget> page = [
    const TicketListPage(),
    AddTicketPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        title: const Text("Helpdesk"),
        backgroundColor: Config.appBarColor)
      ,
      drawer: menulist(),
    body:page[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list),label: 'List'),
          NavigationDestination(icon: Icon(Icons.add),label: 'Add'),
        ],
        onDestinationSelected: (int index){
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex:currentPage,
      ),


    );
    // TODO: implement build
    throw UnimplementedError();
  }
}
import 'package:flutter/material.dart';
import 'package:helpdesk_demo/PollingStationListPage.dart';

import 'helpdesk/ticket_list.dart';

class HomePage extends StatelessWidget {
  final String userRole;

  HomePage({required this.userRole});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {
        'title': 'Schedule',
        'image': 'assets/loginpage_poster.png',
        'action': () {
          // Perform action for "Schedule" item
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PollingStationListPage()),
          );
        },
        'roles': ['admin','APROIT'],
      },
      {
        'title': 'Planning',
        'image': 'assets/loginpage_poster.png',
        'action': () {
          // Perform action for "Planning" item
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PollingStationListPage()),
          );
        },
        'roles': ['admin', 'user'],
      },
      {
        'title': 'Helpdesk',
        'image': 'assets/loginpage_poster.png',
        'action': () {
          // Perform action for "Helpdesk" item
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TicketListPage()),
          );
        },
        'roles': ['admin', 'user'],
      },
      {
        'title': 'Profile',
        'image': 'assets/loginpage_poster.png',
        'action': () {
          // Perform action for "Profile" item
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TicketListPage()),
          );
        },
        'roles': ['admin', 'user'],
      },
    ];

    List<Map<String, dynamic>> filteredItems = items.where((item) {
      return item['roles'].contains(userRole);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Home Page',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return ListTile(
                  title: Center(
                    child: Container(
                      // width: MediaQuery.of(context).size.width * 0.8, // Adjust the multiplier as desired
                      //height: 100, // Adjust the height as desired
                      child: Image.asset(
                        item['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  subtitle: Center(
                    child: Text(
                      item['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: item['action'],
                  dense: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

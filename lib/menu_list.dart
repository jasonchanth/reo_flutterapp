import 'package:flutter/material.dart';
import 'package:helpdesk_demo/HomePage.dart';
import 'package:helpdesk_demo/widgets/task_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PollingStationDetailsPage.dart';
import 'PollingStationListPage.dart';
import 'PollingStationSchedule.dart';
import 'TicketListPage.dart';
import 'main.dart'; // Assuming you have a separate LoginPage

class menulist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          FutureBuilder<String?>(
            future: _getUsername(),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While waiting for the username, show a loading indicator
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                // Once the username is available, display it in the header
                return UserAccountsDrawerHeader(
                  accountName: Text(
                    snapshot.data!,
                  ),
                  accountEmail: Text(
                    "A0101",
                  ),
                  currentAccountPicture: CircleAvatar(
                      // backgroundImage: new AssetImage("assets/images/logo.png"),
                      ),
                );
              } else {
                // If there's an error or no username found, display a default header
                return UserAccountsDrawerHeader(
                  accountName: Text("Guest"),
                  accountEmail: Text(""),
                  currentAccountPicture: CircleAvatar(
                      // backgroundImage: new AssetImage("assets/images/logo.png"),
                      ),
                );
              }
            },
          ),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.chrome_reader_mode)),
            title: Text('Home Page'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                // MaterialPageRoute(builder: (context) => HomePage(userRole: 'admin')),
                MaterialPageRoute(
                    builder: (context) => TaskWidget(userRole: 'admin')),
              );
            },
          ),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.chrome_reader_mode)),
            title: Text('Setup'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                // MaterialPageRoute(builder: (context) => HomePage(userRole: 'admin')),
                MaterialPageRoute(
                    builder: (context) => PollingStationDetailsPage()),
              );
            },
          ),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.code)),
            title: Text('Schedule'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => PollingStationListPage()),
              );
            },
          ),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.computer)),
            title: Text('helpdesk'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TicketListPage()),
              );
            },
          ),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.logout)),
            title: Text('Logout'),
            onTap: () {
              // Clear the SharedPreferences and navigate to the login page
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  Future<String?> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

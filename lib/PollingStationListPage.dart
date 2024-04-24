import 'package:flutter/material.dart';
import 'package:helpdesk_demo/PollingStation.dart';
import 'package:helpdesk_demo/PollingStationDetailsPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'PollingStationSchedule.dart';
import 'Ticket.dart';
import 'configuration/config.dart';
import 'main.dart';
import 'TicketDetailsPage.dart';
import 'AddTicketPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu_list.dart';

import 'MyFirebaseMessagingService.dart';

class PollingStationListPage extends StatefulWidget {
  const PollingStationListPage({Key? key}) : super(key: key);

  @override
  _PollingStationListPageState createState() => _PollingStationListPageState();
}

class _PollingStationListPageState extends State<PollingStationListPage> {
  List<PollingStation> pollingStations = [];
  bool _isRefreshing = false;

  ScrollController _scrollController = ScrollController();
  late String username = ""; // New variable to store the username

  @override
  void initState() {
    super.initState();
    fetchUsername();
    fetchTickets();
    _scrollController.addListener(_onScroll);
    MyFirebaseMessagingService.registerNotification();
  }

  // Fetch the username from shared preferences
  Future<void> fetchUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        username = prefs.getString('username') ?? '';
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _refreshData();
    }
  }

  Future<void> fetchTickets() async {
    //final response = await http.get(Uri.parse('http://192.168.3.12/helpdesk/TicketData_app.php'));
    final dio = Dio();
    //final url = Uri.parse('${Config.apiUrl}ticketlist/1');
    final url = '${Config.apiUrl}pollingstationlist/1';
print(url);
   // final response = await http.get(url,headers: {'Accept-Charset': 'utf-8'},);
   // final response = await dio.get(url,options:Options(headers: {'Accept-Charset': 'utf-8'}));
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      //final responseBody = utf8.decode(response.bodyBytes);
      //final ticketData = json.decode(responseBody) as List<dynamic>;
      final pollingStationList = response.data as List<dynamic>;
      print(pollingStationList);
      setState(() {
        pollingStations = pollingStationList.map((data) {
          final id = data['id'] ?? '';
          final owner = data['owner'] ?? '';
          final address = data['address'] ?? '';
          final phone = data['phone'] ?? '';

          return PollingStation(
            id: id.toString(),
            owner: owner.toString(),
            address: address.toString(),
            phone: phone.toString(),
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to fetch tickets');
    }
  }

  Future<void> _refreshData() async {
    if (!_isRefreshing) {
      setState(() {
        _isRefreshing = true;
      });
      try {
        // Fetch new ticket data
        await fetchTickets().timeout(Duration(seconds: 10));
        ;
        await Future.delayed(Duration(seconds: 2));
      } catch (e) {
        print('Error: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Connection Error'),
            content: Text('Failed to connect to the server.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polling Station List - $username'),
      ),
      drawer: menulist(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              if (pollingStations.isEmpty) // Add a condition to check if the list is empty
                ElevatedButton(
                  onPressed: _refreshData,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(double.infinity, 100.0),
                    ),
                  ),
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ListView.separated(
                shrinkWrap: true,
                controller: _scrollController,
                //itemCount: pollingStations.length + 1,
                itemCount: pollingStations.length ,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index ) {
/*
                  if (index == pollingStations.length) {

                    return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddTicketPage()),
                        );
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(double.infinity,
                              48.0), // Customize the button height here
                        ),
                      ),
                      child: Text(
                        'Add Ticket',
                        style: TextStyle(
                          fontSize: 40, // Adjust the font size here
                          //color: Colors.white,
                        ),
                      ),
                    );
                  }*/

                  final pollingStation = pollingStations[index];
                  Color statusColor;

                  /* Set the button color based on the ticket status
                  switch (ticket.status) {
                    case 'NEW':
                      statusColor = Colors.green;
                      break;
                    case 'IN-PROGRESS':
                      statusColor = Colors.yellow;
                      break;
                    case 'Escalated':
                      statusColor = Colors.red;
                      break;
                    case 'Closed':
                    default:
                      statusColor = Colors.grey;
                  }*/

                  return ListTile(
                    title: Text(
                      pollingStation.id,
                      style: TextStyle(
                       // fontFamily: 'SimSun',
                        fontSize: 25, // Adjust the font size here
                        //color: Colors.white,
                      ),
                    ),
                    subtitle: Text(pollingStation.address),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                               // TicketDetailsPage(ticket: ticket),
                            PollingStationSchedule(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        minimumSize: MaterialStateProperty.all<Size>(
                          const Size(140, 36), // Customize the button size here
                        ),
                      ),
                      child: Text(
                        pollingStation.owner,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                            //  TicketDetailsPage(ticket: ticket),
                          PollingStationSchedule(),
                        ),
                      );
                    },

                  );

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

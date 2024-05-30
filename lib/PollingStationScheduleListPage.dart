import 'package:flutter/material.dart';
import 'package:helpdesk_demo/PollingStation.dart';
import 'package:helpdesk_demo/pollingStation/pollingStation_main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'PollingStationSchedule.dart';
import 'helpdesk/Ticket.dart';
import 'configuration/config.dart';
import 'main.dart';
import 'helpdesk/ticket_details.dart';
import 'helpdesk/ticket_add.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu_list.dart';

import 'MyFirebaseMessagingService.dart';

class PollingStationScheduleListPage extends StatefulWidget {
  const PollingStationScheduleListPage({super.key});

  @override
  _PollingStationScheduleListPageState createState() => _PollingStationScheduleListPageState();
}

class _PollingStationScheduleListPageState extends State<PollingStationScheduleListPage> {
  List<PollingStation> nonScheduledPollingStationsList = [];
  List<PollingStation> scheduledPollingStationsList = [];
  bool _isRefreshing = false;

  ScrollController _scrollController = ScrollController();
  late String username = ""; // New variable to store the username

  @override
  void initState() {
    super.initState();
    fetchUsername();
    fetchNonScheduledPSList();
    fetchScheduledPSList();
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

  Future<void> fetchNonScheduledPSList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userID = prefs.getString('userID');
    final dio = Dio();
    final url = '${Config.apiUrl}nonscheduledpollingstationlist/$userID';
    print(url);
    final response = await dio.get(
      url,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200) {
      final pollingStationList = response.data as List<dynamic>;
      print(pollingStationList);
      setState(() {
        nonScheduledPollingStationsList = pollingStationList.map((data) {
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
  Future<void> fetchScheduledPSList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userID = prefs.getString('userID');
    final dio = Dio();
    final url = '${Config.apiUrl}scheduledpollingstationlist/$userID';
    print(url);
    final response = await dio.get(
      url,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200) {
      final pollingStationList = response.data as List<dynamic>;
      print(pollingStationList);
      setState(() {
        scheduledPollingStationsList = pollingStationList.map((data) {
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
        await fetchNonScheduledPSList().timeout(Duration(seconds: 10));
        ;
        await Future.delayed(Duration(seconds: 2));
      } catch (e) {
        print('Error: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Connection Error'),
            content: const Text('Failed to connect to the server.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
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
        backgroundColor: Config.appBarColor,
      ),
      drawer: menulist(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              if (nonScheduledPollingStationsList
                  .isEmpty) // Add a condition to check if the list is empty
                ElevatedButton(
                  onPressed: _refreshData,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(double.infinity, 100.0),
                    ),
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              const Text('in progress',
                style: TextStyle(
                  // fontFamily: 'SimSun',
                  fontSize: 25,
                  backgroundColor:Colors.yellow,
                    fontWeight: FontWeight.bold// Adjust the font size here
                  //color: Colors.white,
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                controller: _scrollController,
                //itemCount: pollingStations.length + 1,
                itemCount: nonScheduledPollingStationsList.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
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

                  final pollingStation = nonScheduledPollingStationsList[index];
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
                            PollingStationMain(pollingStation:pollingStation,initialPage:1),
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
                        style: const TextStyle(
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
                          PollingStationMain(pollingStation:pollingStation,initialPage:1),
                        ),
                      );
                    },
                  );
                },
              ),
              const Text('Scheduled',
                style: TextStyle(
                  // fontFamily: 'SimSun',
                  fontSize: 25,
                    backgroundColor:Colors.green,
                    fontWeight: FontWeight.bold// Adjust the font size here
                  //color: Colors.white,
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                controller: _scrollController,
                //itemCount: pollingStations.length + 1,
                itemCount: scheduledPollingStationsList.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
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

                  final pollingStation = scheduledPollingStationsList[index];
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
                          //PollingStationSchedule(),
                          PollingStationMain(pollingStation:pollingStation,initialPage:1),
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

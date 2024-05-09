import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '../Task.dart';
import '../helpdesk/Ticket.dart';
import '../configuration/config.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../menu_list.dart';

import '../MyFirebaseMessagingService.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> taskList = [];
  bool _isRefreshing = false;
  int currentPage = 0;

  ScrollController _scrollController = ScrollController();
  late String username = ""; // New variable to store the username

  @override
  void initState() {
    super.initState();
    fetchUsername();
    fetchTasks();
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

  Future<void> fetchTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    //final response = await http.get(Uri.parse('http://192.168.3.12/helpdesk/TicketData_app.php'));
    final dio = Dio();
    //final url = Uri.parse('${Config.apiUrl}ticketlist/1');
    const url = '${Config.apiUrl}task/A1010';
    print(url);
    // final response = await http.get(url,headers: {'Accept-Charset': 'utf-8'},);
    // final response = await dio.get(url,options:Options(headers: {'Accept-Charset': 'utf-8'}));
    final response = await dio.get(
      url,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200) {
      //final responseBody = utf8.decode(response.bodyBytes);
      //final ticketData = json.decode(responseBody) as List<dynamic>;
      final taskData = response.data as List<dynamic>;
      setState(() {
        taskList = taskData.map((data) {
          final id = data['id'] ?? '';
          final pollingStationId = data['pollingstationid'] ?? '';
          final task1 = data['task1']?? 'Complete';
          final task2 = data['task2']?? 'Complete';
          final task3 = data['task3']?? 'Complete';
          final task4 = data['task4']?? 'Complete';
          final task5 = data['task5']?? 'Complete';
          final task6 = data['task6']?? 'Complete';
          final task7 = data['task7']?? 'Complete';
          final totalActiveTable = data['totalActiveTable'] ?? '';

          return Task(
            id: id.toString(),
            pollingStationId: pollingStationId.toString(),
            task1: task1.toString(),
            task2: task2.toString(),
            task3: task3.toString(),
            task4: task4.toString(),
            task5: task5.toString(),
            task6: task6.toString(),
            task7: task7.toString(),
            totalActiveTable: totalActiveTable.toString(),
          );
        }).cast<Task>().toList();
      });
    } else {
      throw Exception('Failed to fetch tickets');
    }
   // print('taskList'+taskList.length());
  }

  Future<void> _refreshData() async {
    if (!_isRefreshing) {
      setState(() {
        _isRefreshing = true;
      });
      try {
        // Fetch new ticket data
        await fetchTasks().timeout(const Duration(seconds: 10));
        ;
        await Future.delayed(const Duration(seconds: 2));
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
        if (mounted) {
          setState(() {
            _isRefreshing = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: Text('Ticket List - $username'),
      ),
      drawer: menulist(),*/
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              if (taskList
                  .isEmpty) // Add a condition to check if the list is empty
                ElevatedButton(
                  onPressed: _refreshData,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 100.0),
                    ),
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ListView.separated(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: 7,
                separatorBuilder: (context, index) => const Divider(),

                itemBuilder: (context, index) {

                  final task = taskList.firstOrNull;
                  //final task = taskList[0];
                  final dateTimeList = [
                    task?.task1,
                    task?.task2,
                    task?.task3,
                    task?.task4,
                    task?.task5,
                    task?.task6,
                    task?.task7,
                    task?.totalActiveTable,
                  ];

                  Color statusColor;

                  // Set the button color based on the ticket status
                  switch (dateTimeList[index]) {
                    case 'Complete':
                      statusColor = Colors.grey;
                      break;
                    case 'Null':
                      statusColor = Colors.grey;
                      break;
                    default:
                      statusColor = Colors.green;
                  }

                  if (index == 6 && (dateTimeList[index] != dateTimeList[index+1])) {
                    statusColor = Colors.grey;
                  }

                  return ListTile(
                    title: Text(
                      'Task ${index+1}',
                      style: const TextStyle(
                        // fontFamily: 'SimSun',
                        fontSize: 30, // Adjust the font size here
                        //color: Colors.white,
                      ),
                    ),
                    subtitle: const Text('XXX XXX XXX'),
                    trailing: ElevatedButton(
                      onPressed: () {

                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(statusColor),
                        minimumSize: MaterialStateProperty.all<Size>(
                          const Size(100, 100), // Customize the button size here
                        ),
                      ),
                      child:index == 6 ?
                      Text(
                        "${dateTimeList[index]}/${dateTimeList[index+1]}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      )
                          :Text(
                        dateTimeList[index].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {

                    },

                  );
                },
              ),
            ],
          ),
        ),
      ),
      /*bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home),label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search),label: 'seach'),
        ],
        onDestinationSelected: (int index){
          setState(() {
            currentPage = index;
          });
        },
          selectedIndex:currentPage,
      ),*/
    );
  }
}

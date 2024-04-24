import 'package:flutter/material.dart';

import 'Task.dart';
import 'menu_list.dart';

class PollingStationDetailsPage extends StatefulWidget {
  @override
  _PollingStationDetailsPageState createState() =>
      _PollingStationDetailsPageState();
}

class _PollingStationDetailsPageState extends State<PollingStationDetailsPage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    // Call your web service to fetch the task list and completion status
    fetchTasks().then((taskList) {
      setState(() {
        tasks = taskList;
      });
    });
  }

  Future<List<Task>> fetchTasks() async {
    // Replace this with your web service call to fetch the task list
    // You can use any networking library or package of your choice
    // Here's a simple example using the http package:
    // final response = await http.get('your_api_endpoint');
    // if (response.statusCode == 200) {
    //   final data = json.decode(response.body);
    //   // Parse the response data and create a list of Task objects
    //   return List<Task>.from(data.map((task) => Task.fromJson(task)));
    // } else {
    //   throw Exception('Failed to fetch tasks');
    // }

    // For demonstration purposes, let's return a hardcoded list of tasks
    return [
      Task(name: 'Task 1', isCompleted: true),
      Task(name: 'Task 2', isCompleted: true),
      Task(name: 'Task 3', isCompleted: false),
      Task(name: 'Task 4', isCompleted: true),
      Task(name: 'Task 5', isCompleted: false),
      Task(name: 'Task 6', isCompleted: false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polling Station Details'),
      ),
      drawer: menulist(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Station Code: ABC123',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Address: 123 Main Street',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tel: 123-456-7890',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Documents:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // Handle document download
                    },
                    child: Text('Download Document 1'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle document download
                    },
                    child: Text('Download Document 2'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle document download
                    },
                    child: Text('Download Document 3'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle document download
                    },
                    child: Text('Download Document 4'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle document download
                    },
                    child: Text('Download Document 5'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle document download
                    },
                    child: Text('Download Document 6'),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tasks:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 300, // Set a specific height as per your UI design
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return ListTile(
                          title: Text(task.name),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Handle task completion for the specific task
                              // You can update the completion status in the web service or locally
                            },
                            child: Text(
                                task.isCompleted ? 'Completed' : 'Pending'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
/*
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tasks:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.name),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Handle task completion for the specific task
                    // You can update the completion status in the web service or locally
                  },
                  child: Text(task.isCompleted ? 'Completed' : 'Pending'),
                ),
              );
            },
          ),*/
          ],
        ),
      ),
    );
  }
}

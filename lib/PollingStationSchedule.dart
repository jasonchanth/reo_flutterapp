import 'package:flutter/material.dart';

import 'menu_list.dart';

class PollingStationSchedule extends StatefulWidget {
  @override
  _PollingStationScheduleState createState() => _PollingStationScheduleState();
}

class _PollingStationScheduleState extends State<PollingStationSchedule> {
  final List<String> _tasks = [
    'Task 1',
    'Task 2',
    'Task 3',
    'Task 4',
    'Task 5',
    'Task 6',
    'Task 7',
  ];

  final List<List<bool>> _completedTasks = List.generate(
    7,
        (_) => [false, false, false, false, false, false, false],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polling Station Information'),
      ),

      drawer: menulist(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Polling Station Information',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ],
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Station Code:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '12345',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Address:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '123 Main St',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Owner:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    'John Doe',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phone:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    '555-555-5555',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length + 1, // Add 1 for the additional ListTile
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Display "Mon" to "Sat" labels
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          SizedBox(width: 35.0), // Empty space for alignment
                          Text('Mon'),
                          Text('Tue'),
                          Text('Wed'),
                          Text('Thu'),
                          Text('Fri'),
                          Text('Sat'),
                          Text('Sun'),
                        ],
                      ),
                    );
                  } else {
                    // Display task and checkboxes
                    int taskIndex = index - 1; // Adjust the index to match the tasks

                    return Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              SizedBox(width: 5.0),
                              Text(
                                _tasks[taskIndex],
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 48.0), // Empty space for alignment
                              Checkbox(
                                value: _completedTasks[taskIndex][0],
                                onChanged: (value) {
                                  setState(() {
                                    _completedTasks[taskIndex][0] = value ?? false;
                                  });
                                },
                              ),
                              Checkbox(
                                value: _completedTasks[taskIndex][1],
                                onChanged: (value) {
                                  setState(() {
                                    _completedTasks[taskIndex][1] = value ?? false;
                                  });
                                },
                              ),
                              Checkbox(
                                value: _completedTasks[taskIndex][2],
                                onChanged: (value) {
                                  setState(() {
                                    _completedTasks[taskIndex][2] = value ?? false;
                                  });
                                },
                              ),
                              Checkbox(
                                value: _completedTasks[taskIndex][3],
                                onChanged: (value) {
                                  setState(() {
                                    _completedTasks[taskIndex][3] = value ?? false;
                                  });
                                },
                              ),
                              Checkbox(
                                value: _completedTasks[taskIndex][4],
                                onChanged: (value) {
                                  setState(() {
                                    _completedTasks[taskIndex][4] = value ?? false;
                                  });
                                },
                              ),
                              Checkbox(
                                value: _completedTasks[taskIndex][5],
                                onChanged: (value) {
                                  setState(() {
                                    _completedTasks[taskIndex][5] = value ?? false;
                                  });
                                },
                              ),

                  Checkbox(
                    value: _completedTasks[taskIndex][6],
                    onChanged: (value) {
                      setState(() {
                        _completedTasks[taskIndex][6] = value ?? false;
                      });
                    },
                  ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
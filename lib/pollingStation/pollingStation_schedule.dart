import 'package:flutter/material.dart';

import '../Schedule.dart';
import '../configuration/config.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PollingStationSchedule extends StatefulWidget {
  final pollingStation;
  const PollingStationSchedule({super.key, required this.pollingStation});

  @override
  State<PollingStationSchedule> createState() => _PollingStationScheduleState();
}

class _PollingStationScheduleState extends State<PollingStationSchedule> {
  List<Schedule> scheduleList = [Schedule(id:'1', pollingStationId: 'A1010', task1: '1', task2: '1', task3: '1', task4: '1', task5: '1', task6: '1', task7: '1')];
  String dropDownValue = 'Monday';
  int documentCount = 7;
  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  late List<String> dropDownValues =
      List.generate(documentCount, (index) => 'Monday');

  @override
  void initState() {
    super.initState();
    fetchSchedule();
    //dropDownValues = List.generate(documentCount, (index) => 'Mon');
  }
  Future<void> fetchSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final dio = Dio();
    String url = '${Config.apiUrl}schedule/${widget.pollingStation.id}';
    print(url);
    final response = await dio.get(
      url,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print(response.data);
    if (response.statusCode == 200) {
      //final responseBody = utf8.decode(response.bodyBytes);
      //final ticketData = json.decode(responseBody) as List<dynamic>;
      final scheduleData = response.data as List<dynamic>;
      setState(() {
        scheduleList = scheduleData.map((data) {
          final id = data['id'] ?? '';
          final pollingStationId = data['pollingstationid'] ?? '';
          final task1 = data['task1']?? '';
          final task2 = data['task2']?? '';
          final task3 = data['task3']?? '';
          final task4 = data['task4']?? '';
          final task5 = data['task5']?? '';
          final task6 = data['task6']?? '';
          final task7 = data['task7']?? '';

          return Schedule(
            id: id.toString(),
            pollingStationId: pollingStationId.toString(),
            task1: task1.toString(),
            task2: task2.toString(),
            task3: task3.toString(),
            task4: task4.toString(),
            task5: task5.toString(),
            task6: task6.toString(),
            task7: task7.toString(),
          );
        }).cast<Schedule>().toList();
      });
    } else {
      throw Exception('Failed to fetch tickets');
    }
    // print('taskList'+taskList.length());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documentCount,
      itemBuilder: (context, index) {

        return ListTile(
          title: Text(
            "Task ${index + 1}",
            style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: DropdownButton<String>(
            borderRadius: BorderRadius.circular(12),
            value: getSelectedValue(index),
            icon: const Icon(Icons.menu),
            //items: getDropdownItems(),
            items: [
              DropdownMenuItem<String>(value: '1', child: Text('Monday',style: const TextStyle(
                fontSize: 30,
              ),)),
              DropdownMenuItem<String>(value: '2', child: Text('Tuesday',style: const TextStyle(
                fontSize: 30,
              ),)),
              DropdownMenuItem<String>(value: '3', child: Text('Wednesday',style: const TextStyle(
                fontSize: 30,
              ),)),
              DropdownMenuItem<String>(value: '4', child: Text('Thursday',style: const TextStyle(
                fontSize: 30,
              ),)),
              DropdownMenuItem<String>(value: '5', child: Text('Friday',style: const TextStyle(
                fontSize: 30,
              ),)),
              DropdownMenuItem<String>(value: '6', child: Text('Saturday',style: const TextStyle(
                fontSize: 30,
              ),)),
              DropdownMenuItem<String>(value: '7', child: Text('Sunday',style: const TextStyle(
                fontSize: 30,
              ),)), // 不再重复
            ],

            onChanged: (String? newValue) {
              setState(() {
                dropDownValues[index] = newValue!;
              });
            },
          ),
          shape: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }

  String? getSelectedValue(int index) {
    switch (index) {
      case 0:
        return scheduleList.first.task1;
      case 1:
        return scheduleList.first.task2;
      case 2:
        return scheduleList.first.task3;
      case 3:
        return scheduleList.first.task4;
      case 4:
        return scheduleList.first.task5;
      case 5:
        return scheduleList.first.task6;
      case 6:
        return scheduleList.first.task7;
      default:
        return null;
    }
  }

  List<DropdownMenuItem<String>> getDropdownItems() {
    return days.map((String value) {
      return DropdownMenuItem(
        value: value,
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
      );
    }).toList();
  }
}

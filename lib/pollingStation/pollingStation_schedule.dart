import 'package:flutter/material.dart';


class PollingStationSchedule extends StatefulWidget {
  const PollingStationSchedule({super.key});

  @override
  State<PollingStationSchedule> createState() => _PollingStationScheduleState();
}

class _PollingStationScheduleState extends State<PollingStationSchedule> {
  String dropDownValue = 'Monday';
  int documentCount = 7;
  List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  late List<String> dropDownValues = List.generate(documentCount, (index) => 'Monday');

  @override
  void initState() {
    super.initState();
    //dropDownValues = List.generate(documentCount, (index) => 'Mon');
  }

  @override
  Widget build(BuildContext context) {




          return ListView.builder(
            itemCount: documentCount,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("Task ${index + 1}"),
                subtitle: const Text("XXX XXX XXX"),
                trailing: DropdownButton<String>(

                  value: dropDownValues[index],
                  icon: const Icon(Icons.menu),
                  items: days.map((String value) {  // 使用map方法将日期数组映射到下拉菜单项上
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {  // 添加一个onChanged回调函数来更新选中的日期
                    setState(() {
                      dropDownValues[index] = newValue!;
                    });
                  },
                ),
              );
            },
          );

  }
}

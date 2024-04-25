import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../configuration/config.dart';

class TaskWidget extends StatefulWidget {
  final String userRole;

  TaskWidget({required this.userRole});

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  List<dynamic> menuList = [];

  @override
  void initState() {
    super.initState();
    _fetchMenuData();
  }

  Future<void> _fetchMenuData() async {
    try {
      Response response = await Dio().get('${Config.apiUrl}usermenu/admin');
      setState(() {
        menuList = response.data;
      });
    } catch (e) {
      print('Error fetching menu data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('選舉事務',style: TextStyle(
            fontSize: 35)),
          backgroundColor: Config.appBarColor
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: ListView.builder(
          itemCount: menuList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                String menuPath = menuList[index]['menuPath'];
                if (Config.pageRoutes.containsKey(menuPath)) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Config.pageRoutes[menuPath]!),
                  );
                }
                // Navigate to menuPath
              },
              child: Card(
                child: Column(
                  children: <Widget>[
                    Image.network(menuList[index]['menuImg']),
                    Text(
                      menuList[index]['menuName'],
                      style: TextStyle(
                          fontSize: 35), // You can adjust the font size here
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk_demo/threadData.dart';

import 'Ticket.dart';

import '../MyFirebaseMessagingService.dart';
import '../configuration/config.dart';
import '../menu_list.dart';

import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

class TicketDetailsPage extends StatefulWidget {
  final Ticket ticket;

  const TicketDetailsPage({Key? key, required this.ticket}) : super(key: key);

  @override
  _TicketDetailsPageState createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  TextEditingController _messageController = TextEditingController();
  String _message = '';
  List<ThreadData> threadData = [];

  @override
  void initState() {
    super.initState();
    MyFirebaseMessagingService.registerNotification();
    fetchThreadData();
  }

  Future<void> fetchThreadData() async {
    //final response = await http.get(Uri.parse('http://192.168.3.12/helpdesk/TicketData_app.php'));
    final url = Uri.parse('${Config.apiUrl}threads/${widget.ticket.id}');
    print(url);
    //final response = await http.get(url,headers: {'Accept-Charset': 'utf-8'},);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final ticketData = json.decode(responseBody) as List<dynamic>;
      print(ticketData);
      if (mounted) {
        setState(() {
          threadData = ticketData.map((data) {
            final type = data['userId'] ?? '';
            final subject = data['message'] ?? '';
            final details = data['message'] ?? '';
            final status = data['status_name'] ?? '';
            final updatedAt = data['updatedAt'] ?? '';

            return ThreadData(
              username: type.toString(),
              comment: subject.toString(),
              hasImage: details.toString(),
            );
          }).toList();
        });
      }
    } else {
      throw Exception('Failed to fetch tickets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Type: ${widget.ticket.type}',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Subject: ${widget.ticket.subject}',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Details: ${widget.ticket.details}',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Status: ${widget.ticket.status}',
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(height: 20),

            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: threadData.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final item = threadData[index];
                return ListTile(
                  leading: Text(
                    item.username,
                    style: TextStyle(fontSize: 20),
                  ),
                  title: Text(
                    item.comment,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    item.comment,
                    style: TextStyle(fontSize: 20),
                  ),
                );
              },
            ),

            //SizedBox(height: 100),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Message: $_message',
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter your message',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // 添加用于从相机/相册拍照并在用户单击提交按钮时提交的按钮
            ElevatedButton(
              onPressed: () {
                // 拍照或选择相册图片并提交
                // 注意：需要在 pubspec.yaml 文件中添加相机权限和相册权限
                // 参考：https://pub.dev/packages/image_picker

                // 在此添加调用相机或相册的代码
              },
              child: Text('Take Photo'),
            ),

            ElevatedButton(
              onPressed: () {
                final ticketID = widget.ticket.id; // Get the ticket ID
                final userID = '1'; // Replace with the actual user ID
                final ticketType = 'update'; // Get the ticket type
                final message = _messageController
                    .text; // Get the message entered by the user

                final url = Uri.parse('${Config.apiUrl}addThreads');
                print(url);
                final headers = {'Content-Type': 'application/json'};
                final body = json.encode({
                  'ticketID': ticketID,
                  'userID': userID,
                  'ticketType': ticketType,
                  'message': message,
                });

                http.post(url, headers: headers, body: body).then((response) {
                  if (response.statusCode == 200) {
                    // Success
                    print('Thread added successfully!');
                    // You can perform any additional actions here after the request is successful
                  } else {
                    // Error
                    print(
                        'Failed to add thread. Error: ${response.statusCode}');
                    // You can handle the error condition here
                  }
                }).catchError((error) {
                  // Exception
                  print('Failed to add thread. Error: $error');
                  // You can handle the exception here
                });
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

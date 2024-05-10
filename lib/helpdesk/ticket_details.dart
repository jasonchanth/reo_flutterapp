import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helpdesk_demo/threadData.dart';

import 'Ticket.dart';

import '../MyFirebaseMessagingService.dart';
import '../configuration/config.dart';
import '../menu_list.dart';

import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class TicketDetailsPage extends StatefulWidget {
  final Ticket ticket;

  const TicketDetailsPage({Key? key, required this.ticket}) : super(key: key);

  @override
  _TicketDetailsPageState createState() => _TicketDetailsPageState();
}
enum MediaSelectionType {
  gallery,
  camera,
}
class _TicketDetailsPageState extends State<TicketDetailsPage> {
  final TextEditingController _messageController = TextEditingController();
  String _message = '';
  List<ThreadData> threadData = [];
  List<File> selectedMedia = [];

  @override
  void initState() {
    super.initState();
    MyFirebaseMessagingService.registerNotification();
    fetchThreadData();
  }

  Future<void> fetchThreadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final dio = Dio();
    //final response = await http.get(Uri.parse('http://192.168.3.12/helpdesk/TicketData_app.php'));
    //final url = Uri.parse('${Config.apiUrl}threads/${widget.ticket.id}');
    final url = '${Config.apiUrl}threads/${widget.ticket.id}';
    print(url);
    //final response = await http.get(url,headers: {'Accept-Charset': 'utf-8'},);
    final response = await dio.get(
      url,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200) {
     // final responseBody = utf8.decode(response.data);
      //final ticketData = json.decode(responseBody) as List<dynamic>;
      final ticketData = response.data as List<dynamic>;
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

  Future<void> _selectMedia(MediaSelectionType selectionType) async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? pickedFile;

      if (selectionType == MediaSelectionType.gallery) {
        pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
        );
      } else if (selectionType == MediaSelectionType.camera) {
        pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
        );
      }

      if (pickedFile == null) return;

      setState(() {
        selectedMedia.add(File(pickedFile!.path));
      });
    } catch (e) {
      print(e.toString());
      //_showErrorNotification(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Type: ${widget.ticket.type}',
                style: const TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Subject: ${widget.ticket.subject}',
                style: const TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Details: ${widget.ticket.details}',
                style: const TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Status: ${widget.ticket.status}',
                style: const TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(height: 20),

            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: threadData.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final item = threadData[index];
                return ListTile(
                  leading: Text(
                    item.username,
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: Text(
                    item.comment,
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    item.comment,
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              },
            ),

            //SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Message: $_message',
                style: const TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _messageController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Enter your message',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // 添加用于从相机/相册拍照并在用户单击提交按钮时提交的按钮
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.camera),
                            title: const Text('打开相机拍照'),
                            onTap: () {
                              _selectMedia(MediaSelectionType.camera);
                              // 在此添加调用相机的代码
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text('打开相册选择照片'),
                            onTap: () {
                              _selectMedia(MediaSelectionType.gallery);
                              // 在此添加调用相册的代码
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Photo'),
              ),
            ),


            Center(
              child: ElevatedButton(
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
                child: const Text('Submit'),
              ),
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

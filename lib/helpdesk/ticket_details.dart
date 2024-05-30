import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:helpdesk_demo/threadData.dart';
import 'Ticket.dart';
import '../MyFirebaseMessagingService.dart';
import '../configuration/config.dart';
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
            final subject = data['createdAt'] ?? '';
            final details = data['message'] ?? '';
            final status = data['status_name'] ?? '';
            final updatedAt = data['updatedAt'] ?? '';
            final image = data['attachment'] ?? '';

            return ThreadData(
              username: type.toString(),
              createdAt: subject.toString(),
              comment: details.toString(),
              hasImage: details.toString(),
              image: image.toString(),
            );
          }).toList();
        });
      }
    } else {
      throw Exception('Failed to fetch tickets');
    }
  }

  Future<void> _submitTicket() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      // Prepare form data
      FormData formData = FormData();
      formData.fields.add(MapEntry('ticketID', widget.ticket.id));
      formData.fields.add(MapEntry('userID', '1'));
      formData.fields.add(MapEntry('ticketType', 'update'));
      formData.fields.add(MapEntry('message', _messageController.text));

      // Add media files
      if (selectedMedia.isNotEmpty) {
        print("select media");
        for (int i = 0; i < selectedMedia.length; i++) {
          formData.files.add(MapEntry(
            'mediaFiles',
            await MultipartFile.fromFile(selectedMedia[i].path),
          ));
        }
      }

      // Send the form data to the server

      print(Config.apiUrl);
      /*Response response = await Dio().post(
        '${Config.apiUrl}addTicket',
        data: formData,
      );*/
      Response response = await Dio().post(
        '${Config.apiUrl}addThreads',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Show success notification
        //_showTicketAddedNotification(context);
        fetchThreadData();
      } else {
        // Show error notification
        //_showErrorNotification(context);
      }
    } catch (e) {
      // Handle any exceptions here
      print(e.toString());
      //  _showErrorNotification(context);
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
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'TicketId: ${widget.ticket.id}',
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Type: ${widget.ticket.type}',
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
              ],
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
                'Status: ${widget.ticket.status}',
                style: const TextStyle(fontSize: 25),
              ),
            ),

            const SizedBox(height: 20),

            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: threadData.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = threadData[index];
                return ListTile(
                  leading: Text(
                    item.username,
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: Text(
                    item.createdAt,
                    style: const TextStyle(fontSize: 15),
                  ),
                  subtitle: Text(
                    item.comment,
                    style: const TextStyle(fontSize: 30),
                  ),
                  trailing: item.image != ''
                      ? GestureDetector(
                          onTap: () {
                            // Handle image enlargement on tap
                            _showEnlargedImage(item.image);
                          },
                          child: Image.network(item.image),
                        )
                      : null, // Handle the case when image is not available
                );
              },
            ),

            //SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(children: [
                Text(
                  'Message: $_message',
                  style: const TextStyle(fontSize: 25),
                ),
                if (selectedMedia.isNotEmpty) ...{
                  Center(
                      child: Image.file(
                    selectedMedia[0],
                    width: 50,
                    height: 50,
                  )),
                },
              ]),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  _submitTicket();
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

  // Function to show enlarged image
  void _showEnlargedImage(String imageUrl) {
    // Implement logic to show the enlarged image, such as using a dialog or a new screen
    // For example:
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.network(imageUrl), // Show the enlarged image in a dialog
        );
      },
    );
  }
}

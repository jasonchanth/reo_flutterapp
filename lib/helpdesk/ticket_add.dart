import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../configuration/config.dart';

class AddTicketPage extends StatefulWidget {
  @override
  _AddTicketPageState createState() => _AddTicketPageState();
}

enum MediaSelectionType {
  gallery,
  camera,
}
class _AddTicketPageState extends State<AddTicketPage> {
  final List<String> ticketTypes = ['Type A', 'Type B', 'Type C'];
  List<File> selectedMedia = [];

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
      _showErrorNotification(context);
    }
  }

  Future<void> _submitTicket() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      // Prepare form data
      FormData formData = FormData();
      formData.fields.add(MapEntry('ticketType', _selectedTicketType));
      formData.fields.add(MapEntry('subject', _subjectController.text));
      formData.fields.add(MapEntry('ticketDetails', _detailsController.text));

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
        '${Config.apiUrl}addTicket',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Show success notification
        _showTicketAddedNotification(context);
      } else {
        // Show error notification
        _showErrorNotification(context);
      }
    } catch (e) {
      // Handle any exceptions here
      print(e.toString());
      _showErrorNotification(context);
    }
  }

  void _showTicketAddedNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ticket added'),
      ),
    );
  }

  void _showErrorNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error adding ticket'),
      ),
    );
  }

  late String _selectedTicketType;
  late TextEditingController _subjectController;
  late TextEditingController _detailsController;
  MediaSelectionType _selectedMediaType = MediaSelectionType.gallery;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController();
    _detailsController = TextEditingController();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaSelectionType? currentSelectionType; // 增加?以便在初始时可能为空
    return Scaffold(
      /*
      appBar: AppBar(
        title: const Text('Add Ticket'),
      ),*/

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                items: ticketTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTicketType = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Ticket Type',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _detailsController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Ticket Details',
                ),
              ),
              DropdownButtonFormField<MediaSelectionType>(
                // 修改此处的类型选择
                value: currentSelectionType,
                items: MediaSelectionType.values.map((type) {
                  return DropdownMenuItem<MediaSelectionType>(
                    value: type,
                    child: Text(type == MediaSelectionType.gallery
                        ? 'gallery'
                        : 'camera'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMediaType = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Media Type',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _selectMedia(_selectedMediaType);
                },
                child: Text(
                  _selectedMediaType == MediaSelectionType.gallery
                      ? 'Select from Album'
                      : 'Capture Media',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _submitTicket();
                },
                child: const Text('Submit Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

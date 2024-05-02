import 'package:flutter/material.dart';
class PollingStationInfo extends StatelessWidget {
  const PollingStationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'Station Code: ABC123',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Address: 123 Main Street 123, Anytown USA 12345',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 8),
              Text(
                'Owner: Miss Chan',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 8),
              Text(
                'Tel: 123-456-7890',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        /*
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
        ),*/
      ],
    );
  }
}

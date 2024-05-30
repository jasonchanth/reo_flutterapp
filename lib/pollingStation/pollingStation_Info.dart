import 'package:flutter/material.dart';

import '../api/MapUtils.dart';
class PollingStationInfo extends StatefulWidget {
  final pollingStation;
  const PollingStationInfo({super.key, required this.pollingStation});

  @override
  State<PollingStationInfo> createState() => _PollingStationInfoState();
}

class _PollingStationInfoState extends State<PollingStationInfo> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              Text(
          'Polling Station: ${widget.pollingStation.id}',
                //'Station Code: ABC123',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'Address: ${widget.pollingStation.address}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 5),
              Text(
                'Facility: G/F Multi function room',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 5),
              Text(
                'Venue Contact: ${widget.pollingStation.phone}',
                style: TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                onPressed: () {
                  //MapUtils.openMap((-3.823216) as double, (-38.481700) as double);
                  MapUtils.pushMap("Hong Kong Convention and Exhibition Centre");
                },
                child: const Text('GPS Location'),
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

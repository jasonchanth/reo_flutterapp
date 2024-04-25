import 'package:flutter/material.dart';
class PollingStationDocument extends StatelessWidget {
  const PollingStationDocument({super.key});

  @override
  Widget build(BuildContext context) {
    int documentCount = 10;
    return  ListView.builder(
      itemCount: documentCount,
      itemBuilder: (context, index) {

        return ListTile(
          title: Text("Documents ${index+1}"),
          subtitle: const Text("Please download the documents from the link below"),
          trailing: const Icon(Icons.download_rounded),
          onTap: () {
            //TODO: Implement download functionality
          },
        );
      }
    );

  }
}

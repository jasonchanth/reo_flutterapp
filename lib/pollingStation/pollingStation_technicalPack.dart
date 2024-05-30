import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class PollingStationTechnicalPack extends StatelessWidget {
  const PollingStationTechnicalPack({super.key});

  @override
  Widget build(BuildContext context) {
    int documentCount = 10;
    return  ListView.builder(
        itemCount: documentCount,
        itemBuilder: (context, index) {

          return ListTile(
            title: Text("Link ${index+1}"),
            subtitle: const Text("Please click the link to the document"),
            trailing: const Icon(Icons.link),
            onTap: () {
              //TODO: Implement download functionality
              _launchURL("https://idea.gov.hk/reo-ed1/Attendance-ITSS/en");
            },
          );
        }
    );

  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}

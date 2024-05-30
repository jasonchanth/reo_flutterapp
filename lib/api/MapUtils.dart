import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();
  static Future<void> openMap(double lat, double long) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  static Future<void>  pushMap(String address) async {
  String query =Uri.encodeComponent(address);
  String googleUrl ="https://www.google.com/maps/search/?api=1&query=$query";
  Uri uri = Uri.parse(googleUrl);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $googleUrl';
  }
  }

}
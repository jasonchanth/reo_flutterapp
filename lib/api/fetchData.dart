import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configuration/config.dart';


class FetchData {
  Future<void> fetchSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    //final response = await http.get(Uri.parse('http://192.168.3.12/helpdesk/TicketData_app.php'));
    final dio = Dio();
    //final url = Uri.parse('${Config.apiUrl}ticketlist/1');
    const url = '${Config.apiUrl}task/A1010';
    print(url);
    // final response = await http.get(url,headers: {'Accept-Charset': 'utf-8'},);
    // final response = await dio.get(url,options:Options(headers: {'Accept-Charset': 'utf-8'}));
    final response = await dio.get(
      url,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print(response.data);

    // print('taskList'+taskList.length());
  }
}
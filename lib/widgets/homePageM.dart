import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:helpdesk_demo/Alert.dart';
import '../PollingStation.dart';
import '../configuration/config.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pollingStation/pollingStation_main.dart';

class HomePageM extends StatefulWidget {
  final String userRole;
  const HomePageM({super.key, required this.userRole});

  @override
  State<HomePageM> createState() => _HomePageMState();
}

class _HomePageMState extends State<HomePageM> {
  List<dynamic> cardData = [];
  List<dynamic> menuList = [];
  List<Alert> alertList = [];
  bool isOfflineMode = false;
  late String role;
  late PollingStation pollingStation;
  late List<PollingStation>  APROITpollingStationList;
  @override
  void initState() {
    super.initState();
    _fetchMenuData();
    _fetchAlerts();
    role = widget.userRole;
    if (role == 'APROIT' || role == 'aproit') {
      _fetchUserMappingData();
      _fetchAPROITData();
    }
  }
  Future<void> _fetchAPROITData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? userID = prefs.getString('userID');
      if (token != null) {
        Options options = Options(headers: {'Authorization': 'Bearer $token'});
        Response response = await Dio().get(
          '${Config.apiUrl}pollingstationlist/$userID',
          options: options,
        );
        setState(() {
          print(response.data);
          final pollingStationList = response.data as List<dynamic>;
          ;
          APROITpollingStationList = pollingStationList.map((data) {
            final id = data['id'] ?? '';
            final owner = data['owner'] ?? '';
            final address = data['address'] ?? '';
            final phone = data['phone'] ?? '';

            return PollingStation(
              id: id.toString(),
              owner: owner.toString(),
              address: address.toString(),
              phone: phone.toString(),
            );
          }).toList();
        });
        pollingStation = APROITpollingStationList[0];
      } else {
        // Handle token not found in SharedPreferences
      }
    } catch (e) {
      print('Error fetching alerts data: $e');

    }
  }

  Future<void> _fetchUserMappingData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String username = prefs.getString('username') ?? '';
      if (token != null) {
        Options options = Options(headers: {'Authorization': 'Bearer $token'});
        Response response = await Dio().get(
          '${Config.apiUrl}usermapping/$username',
          options: options,
        );
        setState(() {
          cardData = response.data;
        });
        print(response.data);
      } else {
        // Handle token not found in SharedPreferences
      }
    } catch (e) {
      print('Error fetching mapping data: $e');
    }
  }

  Future<void> _fetchAlerts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) {
        Options options = Options(headers: {'Authorization': 'Bearer $token'});
        Response response = await Dio().get(
          '${Config.apiUrl}alerts/A0101',
          options: options,
        );
        setState(() {
          print(response.data);
          final alertData = response.data as List<dynamic>;
          ;
          alertList = alertData.map((data) {
            final id = data['id'] ?? '';
            final question = data['question'] ?? '';
            final type = data['type'] ?? '';
            final active = data['active'] ?? '';
            final ps = data['ps'] ?? '';
            final answer = data['answer'] ?? '';

            return Alert(
              id: id.toString(),
              question: question.toString(),
              type: type.toString(),
              active: active.toString(),
              ps: ps.toString(),
              answer: answer.toString(),
            );
          }).toList();
        });
      } else {
        // Handle token not found in SharedPreferences
      }
    } catch (e) {
      print('Error fetching alerts data: $e');

    }
  }

  Future<void> _fetchMenuData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) {
        Options options = Options(headers: {'Authorization': 'Bearer $token'});
        Response response = await Dio().get(
          '${Config.apiUrl}usermenu/${widget.userRole}',
          options: options,
        );
        setState(() {
          menuList = response.data;
        });
      } else {
        // Handle token not found in SharedPreferences
      }
    } catch (e) {
      print('Error fetching menu data: $e');
    }
  }

  // Inside your State class
  Future<void> _toggleOfflineMode(id, ans, ps) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      // Prepare form data
      FormData formData = FormData();
      formData.fields.add(MapEntry('alertid', id));
      formData.fields.add(MapEntry('answer', ans));
      formData.fields.add(MapEntry('PS', ps));

      // Send the form data to the server

      print(Config.apiUrl);
      /*Response response = await Dio().post(
        '${Config.apiUrl}addTicket',
        data: formData,
      );*/
      Response response = await Dio().post(
        '${Config.apiUrl}updateAlert',
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
      } else {
        // Show error notification
        //_showErrorNotification(context);
      }
    } catch (e) {
      // Handle any exceptions here
      print(e.toString());
      //_showErrorNotification(context);
    }
    setState(() {
      _fetchAlerts();
      //isOfflineMode = !isOfflineMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Role homepageM' + widget.userRole);
    print('Role homepageM role:' + role);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('REO-EPR Support',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Expanded(child: Container()),
                  //Icon(Icons.settings, size: 30, color: Colors.blue)
                ],
              ),
              SizedBox(
                height: 20,
              ),
              if ((widget.userRole == 'APROIT' ||
                  widget.userRole == 'aproit'||
                  widget.userRole == 'SPECIALTEAM' ||
                  widget.userRole == 'specialteam')&& cardData.isNotEmpty) ...[
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(80),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 20,
                        offset: Offset(5, 10), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          cardData[0]['role'],
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         Text(
                          cardData[0]['username'],
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                             Text(
                              cardData[0]['phone'],
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 20,
                                    offset: const Offset(
                                        5, 10), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () {launchUrl(Uri.parse("tel:+852 ${cardData[0]['phone']}"));},
                                icon: const Icon(
                                  Icons.phone,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              if (alertList != null && alertList.isNotEmpty) ...{
                Column(
                  children: List.generate(
                    alertList.length,
                    (index) {
                      final alert = alertList[index];
                      print(alert.answer);
                      return Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: alert.answer == ""
                                ? [Colors.red, Colors.red]
                                : [Colors.green, Colors.green],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 20,
                              offset:
                                  Offset(5, 10), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, right: 20, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    alert.question,
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.blueGrey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 20,
                                          offset: const Offset(5,
                                              10), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        _toggleOfflineMode(
                                            alert.id, "1", alert.ps);
                                      },
                                      child: Icon(
                                        alert.answer == ""
                                            ? Icons.download_done
                                            : Icons.done,
                                        color: Colors.green,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              },
              /*const Row(children: [
                Text('Area of Focus',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
              ]),*/
              //Expanded(
              const SizedBox(height: 10),
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: menuList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //横轴三个子widget
                    childAspectRatio: 1.0 //宽高比为1时，子widget
                    ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      String menuPath = menuList[index]['menuPath'];
                      if (Config.pageRoutes.containsKey(menuPath)) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                          if (menuPath == 'PollingStationMain' && (widget.userRole == 'APROIT' || widget.userRole == 'aproit')) {
                            return  PollingStationMain(pollingStation:pollingStation,initialPage:0);
                          } else {
                            return Config.pageRoutes[menuPath]!;
                          }
                        },
                          ),
                        );
                      }
                      // Navigate to menuPath
                    },
                    child: Card(
                      color: Colors.lightBlue[100],
                      shape: RoundedRectangleBorder(
                          side:
                              BorderSide(color: Colors.greenAccent, width: 1)),
                      margin: const EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            height: 120,
                            child: Image.network(
                              menuList[index]['menuImg'],
                              fit: BoxFit.cover,
                            ),
                          ), // Adjust the width as needed),
                          Text(
                            menuList[index]['menuName'],
                            style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight
                                    .bold), // You can adjust the font size here
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              //),
            ],
          ),
        ),
      ),
    );
  }
}

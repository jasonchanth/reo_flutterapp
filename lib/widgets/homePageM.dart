import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../configuration/config.dart';

class HomePageM extends StatefulWidget {
  const HomePageM({super.key, required String userRole});

  @override
  State<HomePageM> createState() => _HomePageMState();
}

class _HomePageMState extends State<HomePageM> {
  List<dynamic> menuList = [];

  @override
  void initState() {
    super.initState();
    _fetchMenuData();
  }
  Future<void> _fetchMenuData() async {
    try {
      Response response = await Dio().get('${Config.apiUrl}usermenu/admin');
      setState(() {
        menuList = response.data;
      });
    } catch (e) {
      print('Error fetching menu data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
        child: Column(
          children: [
            Row(
              children: [
                Text('REO-EPR Support',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Expanded(child: Container()),
                Icon(Icons.settings, size: 30, color: Colors.blue)
              ],
            ),
            SizedBox(
              height: 20,
            ),
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
                    bottomRight: Radius.circular(10)),
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
                padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Elite',
                          style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      const Text('Miss Amy',
                          style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('+852 9394 5354',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
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
                              child: const Icon(Icons.phone,
                                  color: Colors.green, size: 40))
                        ],
                      ),
                    ]),
              ),
            ),
            const SizedBox(height: 30),
            const Row(children: [
              Text('Area of Focus',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
            ]),
            Expanded(
              child: GridView.builder(
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
                                builder: (context) => Config.pageRoutes[menuPath]!),
                          );
                        }
                        // Navigate to menuPath
                      },
                      child: Card(
                        color: Colors.lightBlue[100],
                        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.greenAccent, width: 1)),
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
                                  fontSize: 30, fontWeight: FontWeight.bold), // You can adjust the font size here
                            ),
                          ],
                        ),
                      ),
                    );
                  },

              ),
            ),
          ],
        ),
      ),
    );
  }
}

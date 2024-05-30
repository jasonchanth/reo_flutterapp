import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_demo/notification_badge.dart';
import 'package:helpdesk_demo/widgets/homePageM.dart';
import 'package:helpdesk_demo/widgets/task_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'helpdesk/ticket_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'api/firebase_api.dart';
import 'package:overlay_support/overlay_support.dart';
import 'firebase_options.dart';
import 'PushNotification.dart';
import 'configuration/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {}
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(const LoginApp());
}

//void main() => runApp(const LoginApp());f

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late int _totalNotifications;
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;
  String? fcmToken;

  @override
  void initState() {
    _totalNotifications = 0;
    registerNotification();
    checkForInitialMessage();
    _getToken().then((token) {
      setState(() {
        fcmToken = token;
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');
    String? storedFCMToken = prefs.getString('fcmToken');

    if (storedUsername != null && storedPassword != null) {
      // Login information found, automatically populate the fields and verify login
      _usernameController.text = storedUsername;
      _passwordController.text = storedPassword;
      _verifyLogin(storedUsername, storedPassword, storedFCMToken!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('選舉事務消防'),
          ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/loginpage_poster.png',
                  //width: double.infinity, // Adjust the width as needed
                  //height: 200, // Adjust the height as needed
                  fit: BoxFit.cover,
                ),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    String username = _usernameController.text;
                    String password = _passwordController.text;

                    // Send login information to the server for verification
                    _verifyLogin(username, password, fcmToken);
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(200, 50)),
                    // Adjust the size as needed
                    maximumSize: MaterialStateProperty.all(Size(200, 50)),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 30), // Adjust the font size as needed
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyLogin(
      String username, String password, String? fcMToken) async {
    //final url = Uri.parse('${Config.apiUrl}helpdesk/helpdesk_login.php');
    final url = Uri.parse('${Config.apiUrl}login');
    try {
      print("run login");
      final response = await http.post(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Basic ' +
              base64Encode(utf8.encode('$username:$password')),
        },
        body: {
          'username': username,
          'password': password,
          'fcmToken': fcmToken ?? fcMToken,
        },
      ).timeout(const Duration(seconds: 10));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        bool loginSuccess = responseData['success'];

        if (loginSuccess) {
          // Save login information in shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username);
          await prefs.setString('password', password);
          await prefs.setString('fcmToken', fcmToken!);
          await prefs.setString('userID', responseData['userID'].toString());
          await prefs.setString('token', responseData['token']);
          await prefs.setString('userRole', responseData['userRole']);
          print(responseData);
          print(responseData['userID']);
          print(responseData['userRole']);

          /*// Successful login, navigate to the ticket list page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TicketListPage()),
          );*/
          // Successful login, navigate to the home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              //builder: (context) => HomePage(userRole: 'admin'), // Pass userRole as "admin"
             // builder: (context) => TaskWidget(userRole: 'admin'),
              builder: (context) => HomePageM(userRole: responseData['userRole']),
            ),
          );
        } else {
          // Login failed, show an error message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Invalid credentials'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Error occurred during the login request
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content:
                  const Text('Failed to connect to the server. Please try again.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } on TimeoutException {
      // Timeout occurred
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Connection timeout. Please check your internet connection and try again.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Other error occurred
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            //content: Text('An error occurred. Please try again.'),
            content: Text(error.toString()),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> registerNotification() async {
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessingBackgroudHandler);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        String? title = message.data['title'];
        String? body = message.data['body'];
        PushNotification notification = PushNotification(
          title: title ?? message.notification?.title,
          body: body ?? message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );
        if (mounted) {
          setState(() {
            _notificationInfo = notification;
            _totalNotifications++;
          });
        }
        print(message.notification?.title);
        print(message.notification?.body);
        if (_notificationInfo != null) {
          print('333');
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }
      });
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisions permission");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }
}

Future<String?> _getToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $token');
  return token;
}

Future _firebaseMessingBackgroudHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.notification}");

  await Firebase.initializeApp();
}

bool isValidCredentials(String username, String password) {
  // Perform validation logic here
  // You can check against a hardcoded list of valid credentials or perform a network request for validation
  return (username == 'admin' && password == 'password');
}

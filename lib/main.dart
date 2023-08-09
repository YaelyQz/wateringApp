import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uacj_app/routes/HelpPage.dart';
import 'package:uacj_app/routes/HomePage.dart';
import 'package:uacj_app/routes/AutomaticPage.dart';
import 'package:uacj_app/routes/PlantScrapping.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/*
void main() {
  runApp(const MyApp());
}*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // Initialize the local notifications plugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      // Display the system notification
      await displaySystemNotification(
      flutterLocalNotificationsPlugin,
      message.notification?.title ?? "Notification",
      message.notification?.body ?? "You have a new notification!",
      );
    }
  });
  print(fcmToken);
  runApp(const MyApp());
}

// Function to display a system notification
Future<void> displaySystemNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String title,
    String body,
    ) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    '13', // Replace with your channel ID
    'Default', // Replace with your channel description
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID (optional)
    title, // Title of the notification
    body, // Body of the notification
    platformChannelSpecifics, // Notification details
    payload: 'item x', // Optional payload (you can use this to handle taps on the notification)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  get theme => null;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.blue));
    return MaterialApp(
      title: 'Sistema de Riego',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Inicio'),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                 ListTile(
                  leading: Icon(Icons.home),
                  iconColor: Colors.lightBlue,
                  title: Text('Inicio'),
                  onTap: (){
                    hideMenu(context);
                 },
                ),
                ListTile(
                  leading: const Icon(Icons.water_drop),
                  iconColor: Colors.lightBlue,
                  title: const Text('Riego Automático'),
                  onTap: () {
                    goToAutomatic(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  iconColor: Colors.lightBlue,
                  title: const Text('Información sobre plantas'),
                  onTap: () {
                    goToWebScraping(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  iconColor: Colors.lightBlue,
                  title: const Text('Ayuda'),
                  onTap: () {
                    goToHelp(context);
                  },
                ),
              ],
            ),
          ),
          body: const HomePage(),
        ),
      ),
    );
  }

  void hideMenu(BuildContext context) {
    Navigator.pop(context);
  }

  void goToAutomatic(BuildContext context) {
    hideMenu(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AutomaticPage()));
  }

  void goToWebScraping(BuildContext context) {
    hideMenu(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebScraping()));
  }

  void goToHelp(BuildContext context) {
    hideMenu(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const HelpPage()));
  }
}

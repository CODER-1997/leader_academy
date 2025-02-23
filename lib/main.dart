import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:leader/screens/admin/admin_home_screen.dart';
import 'package:leader/screens/auth/login.dart';
import 'package:leader/screens/home/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:upgrader/upgrader.dart';
import 'controllers/device_controllers/device_controller.dart';
import 'firebase_options.dart';

final shorebirdCodePush = ShorebirdCodePush();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  await Upgrader.clearSavedSettings();
  await DeviceChecker.getDeviceId();
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        canvasColor: Colors.white,
        applyElevationOverlayColor: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Teachers app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var box = GetStorage();

  void setUpPushNotification() async {
    final fcm = await FirebaseMessaging.instance;

    await fcm.requestPermission();

    await FirebaseMessaging.instance.subscribeToTopic("all");
  }

  Future<void> requestSmsPermission() async {
    PermissionStatus status = await Permission.sms.request();

    if (status.isGranted) {
      print("Permission granted");
    } else if (status.isDenied) {
      print("Permission denied. Please grant the permission.");
      await Permission.sms.request();
    } else if (status.isPermanentlyDenied) {
      print("Permission permanently denied. Opening app settings...");
      openAppSettings();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestSmsPermission();
    // setUpPushNotification();
    // LocalNotifications.init();


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: box.read('isLogged') == null
          ? Login()
          : (box.read('isLogged') == '0094' || box.read('isLogged') == '004422'
              ? AdminHomeScreen()
              : HomeScreen()),
    );
  }
}

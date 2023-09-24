import 'package:color_blast/Page/workspace_selection_page.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';


import 'Controller/notification_service.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp();
  //FirebaseCrashlytics.instance.crash();
  Stripe.publishableKey='pk_test_51NIrKYCJoeQc9GZJfcBZzkPPVhjiTegipqcnxtZFtiqpHzjSjif38iRjkUSc097ZVLU984Hg4oxiCV8Mb15XGKSU0039XcrFtf';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'ColorBlast',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: WorkspaceSelectionPage(),
    );
  }
}


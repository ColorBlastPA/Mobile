import 'package:color_blast/Page/forgot_password_page.dart';
import 'package:color_blast/Page/login_page.dart';
import 'package:color_blast/Page/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: LoginPage(),
    );
  }
}


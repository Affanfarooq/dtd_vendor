import 'dart:async';
import 'package:dtd_vendor/Provider/auth_provider.dart';
import 'package:dtd_vendor/Provider/productProvider.dart';
import 'package:dtd_vendor/Screens/addProduct_screen.dart';
import 'package:dtd_vendor/Screens/auth_screen.dart';
import 'package:dtd_vendor/Screens/dashBoard_Screen.dart';
import 'package:dtd_vendor/Screens/forgetPassword_screen.dart';
import 'package:dtd_vendor/Screens/login_screen.dart';
import 'package:dtd_vendor/Screens/product_screen.dart';
import 'package:dtd_vendor/Screens/registration_screeen.dart';
import 'package:dtd_vendor/Screens/test_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ChangeNotifierProvider<ProductProvider>(create: (_) => ProductProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        HomePage.id: (context) => HomePage(),
        LoginScreen.id: (context) => LoginScreen(),
        ResetPassword.id: (context) => ResetPassword(),
        AddProductScreen.id: (context) => AddProductScreen(),
        ProductScreen.id: (context) => ProductScreen(),
        DashBoardScreen.id: (context) => DashBoardScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user == null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
          }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Image.asset(
            "images/vendorLogo.png",
          ),
        ),
      )
    );
  }
}


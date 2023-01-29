import 'package:dtd_vendor/Widgets/image_picker.dart';
import 'package:dtd_vendor/Widgets/register_form.dart';
import 'package:dtd_vendor/Widgets/txt.dart';
import 'package:flutter/material.dart';
class RegisterScreen extends StatefulWidget {
  static const String id = 'register-screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40,),
              child: Image.asset("images/registration.png",scale: 1.8,),
            ),
            ShopPicCard(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  RegisterForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

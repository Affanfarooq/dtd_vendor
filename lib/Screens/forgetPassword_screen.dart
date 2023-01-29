import 'package:dtd_vendor/Provider/auth_provider.dart';
import 'package:dtd_vendor/Widgets/textField.dart';
import 'package:dtd_vendor/Widgets/txt.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'forgetPassword-screen';

  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  String? email;

  @override
  Widget build(BuildContext context) {
    final authData=Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/forget.PNG",
                  scale: 1.4,
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                    text: '',
                    children: [
                      TextSpan(
                          text: 'Forget Password ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red)),
                      TextSpan(
                          text:
                              ' Don\'t worry, Enter your email address, we will send you an email to reset your password',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.red,fontSize: 12)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                textField(
                    label: 'Email',
                    icon: Icon(Icons.email_outlined),
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter email';
                      }
                      final bool isValid =
                          EmailValidator.validate(emailController.text);
                      if (!isValid) {
                        return 'Invalid Email Format';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade400),
                            onPressed: (){
                              if(formKey.currentState!.validate()){
                                email=emailController.text.trim();
                                authData.resetPassword(context, email);
                              }
                            },
                            child:text("Reset Password",Colors.white, FontWeight.w500,
                                14)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dtd_vendor/Provider/auth_provider.dart';
import 'package:dtd_vendor/Screens/forgetPassword_screen.dart';
import 'package:dtd_vendor/Screens/home_screen.dart';
import 'package:dtd_vendor/Screens/registration_screeen.dart';
import 'package:dtd_vendor/Widgets/register_form.dart';
import 'package:dtd_vendor/Widgets/textField.dart';
import 'package:dtd_vendor/Widgets/txt.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  String? email;
  String? password;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 4,
        backgroundColor: Colors.green.withOpacity(0.2),
        loadingWidget: AbsorbPointer(
          absorbing: true,
          child: Center(
            child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: Colors.green.shade800,
                  strokeWidth: 2.5,
                  backgroundColor: Colors.green.shade300,
                )),
          ),
        ),
        animationDuration: Duration(milliseconds: 500));
    final authProvider = Provider.of<AuthProvider>(context);

    loginVendor(email, password, context) async{
      this.email=email;
      try {
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if(userCredential.user!.uid!=null){
          progressDialog.dismiss();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return HomePage();
              },
            ),
          );
          authProvider.message('Login Successfully', context);

        }else{
          progressDialog.dismiss();
          authProvider.message('Failed to sign in...!', context);
        }
      } on FirebaseException catch (e) {
        if (e.code == 'user-not-found') {
          progressDialog.dismiss();
          print("No user found for that Email");
          authProvider.message("No user found for that Email", context);
        } else if (e.code == 'wrong-password') {
          progressDialog.dismiss();
          print("Wrong password");
          authProvider.message("Wrong password", context);
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                  Image.asset("images/vendorLogo.png"),
                  SizedBox(height: 20,),
                  text("Welcome,", Colors.black, FontWeight.w400, 17),
                  SizedBox(height: 5,),
                  text("Please Login...!", Colors.black, FontWeight.w600, 19),
                  SizedBox(height: 20,),
                  textField(
                    label: 'Email',
                    icon: Icon(Icons.email),
                      type: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter email address';
                        }
                        final bool isValid =
                        EmailValidator.validate(emailController.text);
                        if (!isValid) {
                          return "Invalid email format";
                        }
                        return null;
                      }
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, val, child){
                      return textField(
                        suffixIcon: IconButton(onPressed: (){
                          val.visibility();
                        }, icon: val.visible==true?Icon(Icons.visibility_off):Icon(Icons.visibility)),
                        label: 'Password',
                        obsecure: val.visible,
                        line: 1,
                        icon: Icon(Icons.key),
                          type: TextInputType.text,
                          controller: passwordController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter password';
                            }
                            if(val.length<6){
                              return 'Minimum 6 characters';
                            }
                            return null;
                          }
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,elevation: 0),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ResetPassword();
                                },
                              ),
                            );
                          },
                          child: text("Forget Password", Colors.green, FontWeight.w500, 14)),
                    ],
                  ),
                  SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade400),
                          onPressed: () {
                              if (formKey.currentState!.validate()) {
                                email=emailController.text.trim();
                                password=passwordController.text.trim();
                                progressDialog.show();
                                loginVendor(email, password, context);
                              }
                          },
                          child: text("Login", Colors.white, FontWeight.w500, 15))),
                  Row(
                    children: [
                      text("Don't have an account ? ", Colors.black45, FontWeight.w700, 14),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,elevation: 0),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return RegisterScreen();
                                },
                              ),
                            );
                          },
                          child: text("Create a shop", Colors.green, FontWeight.w500, 14))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

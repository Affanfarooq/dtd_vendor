
import 'dart:io';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dtd_vendor/Provider/auth_provider.dart';
import 'package:dtd_vendor/Screens/home_screen.dart';
import 'package:dtd_vendor/Widgets/textField.dart';
import 'package:dtd_vendor/Widgets/txt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var numberController = TextEditingController();
  var shopNameController = TextEditingController();
  var passwordController = TextEditingController();
  var conPasswordController = TextEditingController();
  var locationController = TextEditingController();
  var shopDialogController = TextEditingController();

  String? shopName;
  String? email;
  String? password;
  String? mobile;
  String? dialog;

  Future<String> uploadShopProfilePicToStorage(filePath) async{
     File file=File(filePath);
     FirebaseStorage storage=FirebaseStorage.instance;
     try{
       await storage.ref('Uploads/Shop Profile Pic/${shopName}').putFile(file);
     }on FirebaseException catch(e){
       print(e.toString());
     }

     String downLoadURL=await storage.ref('Uploads/Shop Profile Pic/${shopName}').getDownloadURL();
     return downLoadURL;
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
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

    Future<UserCredential?> registerVendor(email, password, context) async{
      authProvider.emailAssign(email);
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          progressDialog.dismiss();
          print('The password provided is too weak.');
          authProvider.message('The password provided is too weak.', context);
        } else if (e.code == 'email-already-in-use') {
          progressDialog.dismiss();
          print('The account already exists for that email.');
          authProvider.message('The account already exists for that email.', context);
        }
      } catch (e) {
        print(e);
      }
      return userCredential;
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          textField(
              label: "Shop Name",
              icon: Icon(Icons.add_business),
              type: TextInputType.text,
              controller: shopNameController,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter shop name';
                }
                return null;
              }),
          textField(
              label: "Mobile",
              icon: Icon(Icons.phone),
              type: TextInputType.phone,
              controller: numberController,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter mobile number';
                }
                return null;
              },),
          textField(
              label: "Email",
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
              }),
          textField(
              label: "Password",
              icon: Icon(Icons.key_outlined),
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
              },obsecure: true,line: 1),
          textField(
              label: "Confirm Password",
              icon: Icon(Icons.key_outlined),
              type: TextInputType.text,
              controller: conPasswordController,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter confirm password';
                }
                if (passwordController.text != conPasswordController.text) {
                  return "Password does't match";
                }
                return null;
              },line: 1,obsecure: true,),
          textField(
              fontSize: 12,
              read: true,
              label: "Shop Location",
              icon: Icon(Icons.location_pin),
              type: TextInputType.text,
              controller: locationController,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please press navigation button to find live location';
                }
                if (authProvider.shopLatitude == null) {
                  return 'Please press navigation button to find live location';
                }
                return null;
              },
              suffixIcon: Consumer<AuthProvider>(
                builder: (context, val, child){
                  return  IconButton(
                      onPressed: () {
                        locationController.text = "Locating... please wait.";
                        authProvider.getShopAddress().then((value) {
                          if (value != null) {
                              locationController.text =
                              '${val.placeName}\n${val.shopAddress}';
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                Text('Could\'t find location.. try again')));
                          }
                        });
                      },
                      icon: Icon(Icons.location_searching));
                },

              ),
              line: 4),
          textField(
            label: "Shop Dialog/Description",
            icon: Icon(Icons.message),
            type: TextInputType.text,
            controller: shopDialogController,
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade400),
                  onPressed: () {
                    if (authProvider.isPicAvailable == true) {
                      if (formKey.currentState!.validate()) {
                          progressDialog.show();
                          shopName=shopNameController.text.trim();
                          mobile=numberController.text.trim();
                          email=emailController.text.trim();
                          password=passwordController.text.trim();
                          dialog=shopDialogController.text.trim();

                          registerVendor(email, password, context).then((credential){
                          if(credential!.user!.uid!=null){
                            uploadShopProfilePicToStorage(authProvider.image!.path).then((url){
                              if(url!=null){
                                authProvider.saveVendorDataToDb(
                                  url: url,
                                  dialog: dialog,
                                  mobile: mobile,
                                  shopName: shopName,
                                );
                                progressDialog.dismiss();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HomePage();
                                    },
                                  ),
                                );
                                authProvider.message('Successfully creating your shop', context);
                              }else{
                                progressDialog.dismiss();
                                authProvider.message('Failed to upload shop profile pic', context);
                              }
                            });
                          }else{
                            progressDialog.dismiss();
                            authProvider.message('Failed to sign in...!', context);
                          }
                        });
                      }
                    }else{
                      authProvider.message('Shop profile pic need to be added', context);
                    }
                  },
                  child: text("Register", Colors.white, FontWeight.w500, 15)))
        ],
      ),
    );
  }
}

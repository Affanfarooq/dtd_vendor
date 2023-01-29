import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dtd_vendor/Provider/productProvider.dart';
import 'package:dtd_vendor/Screens/dashBoard_Screen.dart';
import 'package:dtd_vendor/Screens/product_screen.dart';
import 'package:dtd_vendor/Services/firebase_service.dart';
import 'package:dtd_vendor/Widgets/txt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardScreen extends StatefulWidget {
  static const String id = 'dashBoard-screen';

  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  String? shopName;
  User? user=FirebaseAuth.instance.currentUser;

  @override
  void initState(){
    getVendorData();
    getConnectivity();
    super.initState();
  }

  Future<DocumentSnapshot> getVendorData() async{
    var result=await FirebaseFirestore.instance.collection('Vendors').doc(user!.uid).get();
    setState((){
      vendorData=result;
      shopImage=vendorData.get('imageUrl');
    });
    return result;
  }
  late StreamSubscription subscription;
  var isDeviceConnected=false;
  bool isAlertSet=false;

  getConnectivity()=>subscription=Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async{
        isDeviceConnected=await InternetConnectionChecker().hasConnection;
        if(!isDeviceConnected && isAlertSet==false){
          shoDialogBox();
          setState(() {
            isAlertSet=true;
          });
        }
      }
  );

  shoDialogBox()=>showCupertinoDialog<String>(context: context, builder: (BuildContext context){
    return CupertinoAlertDialog(
      title: Text("No Connection"),
      content: Text('Please check your internet connection'),
      actions: [
        TextButton(onPressed: () async{
          Navigator.pop(context,'Cancel');
          setState(() {
            isAlertSet=false;
          });
          isDeviceConnected=await InternetConnectionChecker().hasConnection;
          if(!isDeviceConnected){
            shoDialogBox();
            setState(() {
              isAlertSet=true;
            });
          }
        }, child: Text("Ok"))
      ],
    );
  });

  @override
  void dispose() {
    subscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    var provider=Provider.of<ProductProvider>(context);
    provider.getShopName(vendorData!=null?vendorData.get('shopName'):'');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        drawer: NavigationDrawer(vendorData: vendorData),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green,
                    child:
                    Center(child:
                    Text("DASHBOARD",style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700,color: Colors.white,letterSpacing: 3.5),),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

class NavigationDrawer extends StatefulWidget {
  var vendorData;
   NavigationDrawer({required this.vendorData});

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(context,widget.vendorData),
              buildMenuItems(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, var vendorData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        vendorData!=null?Container(
            color: Colors.grey.shade200,
            height: 170,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              shopImage
              ,fit: BoxFit.cover,)): Text(''),
        Container(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    vendorData!=null?vendorData.get('shopName'):
                    '',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        fontFamily: 'BalsamiqSans'),
                  ),
                ),
                Text(
                  vendorData!=null?vendorData.get('shopDialog'):
                  '',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontFamily: 'BalsamiqSans'),textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.dashboard_outlined),
            title: Text('Dashboard'),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>DashBoardScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag_outlined),
            title: Text('Product'),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProductScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_camera_outlined),
            title: Text('Banner'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('Coupins'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Orders'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.stacked_bar_chart),
            title: Text('Reports'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Setting'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: (){},
          ),
        ],
      ),
    );
  }
}


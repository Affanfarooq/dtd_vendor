import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtd_vendor/Screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider with ChangeNotifier{

  XFile? image;
  String pickedError = '';
  bool isPicAvailable = false;
  double? shopLatitude;
  double? shopLongitude;
  String? shopAddress;
  String? placeName;
  String email="";

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 15);
    if (pickedFile != null) {
      this.image = XFile(pickedFile.path);
      notifyListeners();
    } else {
      this.pickedError = 'No image selected';
      print('No image selected');

      notifyListeners();
    }
    return image;
  }

  Future getShopAddress() async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    shopLatitude=_locationData.latitude;
    shopLongitude=_locationData.longitude;
    notifyListeners();

    final coordinates = new Coordinates(_locationData.latitude,_locationData.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var _shopAddress = addresses.first;
    shopAddress=_shopAddress.addressLine;
    placeName=_shopAddress.featureName;
    notifyListeners();
    return _shopAddress;
  }

  Future resetPassword(context, email) async {
    this.email = email;
    notifyListeners();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 7),
          content: Text(
            "Note: Email has been sent now you can change your password\nPlease Login with new password",
            style: TextStyle(fontSize: 16),
          )));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
      );
    }on FirebaseException catch(e){
      if(e.code=='user-not-found'){
        print("No user found for that Email");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "No user found for that Email",
              style: TextStyle(fontSize: 16),
            )));
      }
    }
  }

  message(message,context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$message")));
  }

  Future<void> saveVendorDataToDb({
    String? url,
    String? shopName,
    String? mobile,
    String? dialog,
  }) async{
    User? user=FirebaseAuth.instance.currentUser;
    DocumentReference vendors=FirebaseFirestore.instance.collection('Vendors').doc(user!.uid);
    vendors.set({
      'uid':user.uid,
      'shopName':shopName,
      'mobile':mobile,
      'email': email,
      'shopDialog': dialog,
      'address': '${placeName} : ${shopAddress}',
      'location': GeoPoint(shopLatitude!, shopLongitude!),
      'shopOpen': true,
      'rating': 0.00,
      'totalRating': 0,
      'isTopPicked': false,
      'imageUrl': url,
      'accVerified': false,
    });
  }


  bool visible=true;
  bool visibility(){
    visible=!visible;
    notifyListeners();
    return visible;
  }

  void emailAssign(String email){
    this.email=email;
    notifyListeners();
  }
}
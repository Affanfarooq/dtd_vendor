import 'package:dtd_vendor/Screens/dashBoard_Screen.dart';
import 'package:dtd_vendor/Screens/product_screen.dart';
import 'package:flutter/cupertino.dart';


class DrawerServices{
  Widget DrawerScreen(title){
    if(title=='Dashboard'){
      return DashBoardScreen();
    }
    if(title=='Product'){
      return ProductScreen();
    }
    if(title=='Banner'){
      return DashBoardScreen();
    }
    return DashBoardScreen();
  }
}
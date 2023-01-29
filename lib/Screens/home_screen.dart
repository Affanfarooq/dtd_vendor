import 'package:dtd_vendor/Screens/login_screen.dart';
import 'package:dtd_vendor/Services/drawer_services.dart';
import 'package:dtd_vendor/Widgets/drawerMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home-screen';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  DrawerServices drawerServices=DrawerServices();
  GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();
  String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SliderDrawer(
          appBar: SliderAppBar(
              appBarHeight: 80,
              appBarColor: Colors.white,
              trailing: Row(
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.search)),
                  IconButton(onPressed: (){
                    FirebaseAuth.instance.signOut();
                    // Navigator.pushReplacementNamed(context, LoginScreen.id);
                  }, icon: Icon(Icons.notifications_none))
                ],
              ),
              title: Text('',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700))),
          key: _key,
          sliderOpenSize: 250,
          slider: SliderView(
            onItemClick: (title) {
              _key.currentState!.closeSlider();
              setState(() {
                this.title = title;
              });
            },
          ),
          child: drawerServices.DrawerScreen(title)),
    );
  }
}

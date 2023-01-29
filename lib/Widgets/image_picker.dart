import 'dart:io';
import 'package:dtd_vendor/Provider/auth_provider.dart';
import 'package:dtd_vendor/Widgets/txt.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
class ShopPicCard extends StatefulWidget {
  const ShopPicCard({Key? key}) : super(key: key);

  @override
  State<ShopPicCard> createState() => _ShopPicCardState();
}

class _ShopPicCardState extends State<ShopPicCard> {
  @override
  Widget build(BuildContext context) {
    final authData=Provider.of<AuthProvider>(context);
    return InkWell(
      onTap: (){
        authData.getImage().then((value){
          if(value!=null){
            authData.isPicAvailable=true;
          }
        });
      },
      child: SizedBox(
          height: 230,
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 0,
              child: authData.image==null?Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/upload.PNG",scale: 3,opacity: AlwaysStoppedAnimation(0.2),),
                    text("Add Shop Image", Colors.black45, FontWeight.w500, 12),
                  ],
                ),
              ):Image.file(File(authData.image!.path)))
      ),
    );
  }
}

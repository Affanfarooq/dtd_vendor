import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtd_vendor/Provider/productProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SliderView extends StatefulWidget {
  final Function(String)? onItemClick;
  const SliderView({Key? key,this.onItemClick}) : super(key: key);

  @override
  State<SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView>{
  User? user=FirebaseAuth.instance.currentUser;
  String? shopName;
  var vendorData;

  @override
  void initState(){
    getVendorData();
    super.initState();
  }

  Future<DocumentSnapshot> getVendorData() async{
    var result=await FirebaseFirestore.instance.collection('Vendors').doc(user!.uid).get();
    setState((){
      vendorData=result;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<ProductProvider>(context);
    provider.getShopName(vendorData!=null?vendorData.get('shopName'):'');
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.transparent,
            child: vendorData!=null?CircleAvatar(
              radius: 52,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(vendorData.get('imageUrl')),
            ): Icon(Icons.add_business,size: 50,color: Colors.grey.shade400,),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 200,
              child: Column(
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      vendorData!=null?vendorData.get('shopName'):'',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          fontFamily: 'BalsamiqSans'),
                    ),
                  ),
                  Text(
                    vendorData!=null?vendorData.get('shopDialog'):'',
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
          SizedBox(
            height: 10,
          ),
          _SliderMenuItem(
              title: 'Dashboard', iconData: Icons.dashboard_outlined, onTap: widget.onItemClick!),
          _SliderMenuItem(
              title: 'Product',
              iconData: Icons.shopping_bag_outlined,
              onTap: widget.onItemClick!),
          _SliderMenuItem(
              title: 'Banner',
              iconData: Icons.photo_camera_outlined,
              onTap: widget.onItemClick!),
          _SliderMenuItem(
              title: 'Coupins',
              iconData: Icons.card_giftcard,
              onTap: widget.onItemClick!),
          _SliderMenuItem(
              title: 'Orders', iconData: Icons.list_alt, onTap: widget.onItemClick!),
          _SliderMenuItem(
              title: 'Reports', iconData: Icons.stacked_bar_chart, onTap: widget.onItemClick!),
          _SliderMenuItem(
              title: 'Setting', iconData: Icons.settings_outlined, onTap: widget.onItemClick!),
          _SliderMenuItem(
              title: 'LogOut',
              iconData: Icons.arrow_back_ios,
              onTap: widget.onItemClick!),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function(String) onTap;
  const _SliderMenuItem(
      {Key? key,
        required this.title,
        required this.iconData,
        required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text('${title}',
            style: TextStyle(
                color: Colors.black, fontFamily: 'BalsamiqSans_Regular')),
        leading: Icon(iconData, color: Colors.black),
        onTap: () => onTap.call(title));
  }
}

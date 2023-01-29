import 'package:dtd_vendor/Screens/addProduct_screen.dart';
import 'package:dtd_vendor/Screens/dashBoard_Screen.dart';
import 'package:dtd_vendor/Services/firebase_service.dart';
import 'package:dtd_vendor/Widgets/published.dart';
import 'package:dtd_vendor/Widgets/txt.dart';
import 'package:dtd_vendor/Widgets/un_published.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {

  static const String id = 'product-screen';

  ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
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
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("PRODUCT LIST",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color: Colors.white,letterSpacing: 3),),
                      ElevatedButton.icon(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AddProductScreen()));
                          },
                          icon: Icon(Icons.add),
                          label: Text(
                            "Add New",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
          Column(children: [
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "UN PUBLISHED",
                      style: TextStyle(
                          letterSpacing: 2,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    Text(
                      "Total : 10",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height / 2.9,
                child: SingleChildScrollView(child: UnPublishedProduct())),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PUBLISHED",
                      style: TextStyle(
                          letterSpacing: 2,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    Text(
                      "Total : 10",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
                child: PublishedProduct()),
          ]),
        ],
      ),
    ));
  }
}

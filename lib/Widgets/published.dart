import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtd_vendor/Screens/edit_screen.dart';
import 'package:dtd_vendor/Services/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PublishedProduct extends StatelessWidget {
  const PublishedProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Affan Published");
    FireBaseService service = FireBaseService();

    return Container(
      child: StreamBuilder(
          stream: service.products.where('published', isEqualTo: true).snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapShot) {
            if (snapShot.hasError) {
              return Text('Something went wrong');
            }
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Container(
                height: MediaQuery.of(context).size.height/3,
                child: Center(child: CircularProgressIndicator(strokeWidth: 1.0,),),
              );
            }
            return SingleChildScrollView(
              child: snapShot.data!.docs.length==0?Container(
                height: MediaQuery.of(context).size.height/3,
                child: Center(
                  child: Text('No product published yet'),
                ),
              ):FittedBox(
                child: DataTable(
                  dataRowHeight: 54,
                  columnSpacing: 22,
                  showBottomBorder: true,
                  headingRowHeight: 50,
                  headingRowColor:
                  MaterialStateProperty.all(Colors.grey.shade200),
                  columns: [
                    DataColumn(
                        label: Expanded(
                            flex: 1,
                            child: Text('Product Name'))),
                    DataColumn(label: Text('  Image')),
                    DataColumn(label: Text('   Info')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: productDetail(
                      snapshot: snapShot.data as QuerySnapshot, context: context),
                ),
              ),
            );
          }),
    );
  }
  List<DataRow> productDetail(
      {required QuerySnapshot? snapshot, required BuildContext context}) {
    List<DataRow> newList = snapshot!.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(
            Container(
            width: 150,
            child: Text(document.get('productName')))),
        DataCell(Container(
          width: 60,
          height: 54,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: CachedNetworkImage(
              imageUrl: document.get('productImage'),
              fit: BoxFit.cover,
              progressIndicatorBuilder:
                  (context, url,
                  downloadProgress) =>
                  Center(
                      child: Icon(
                        Icons.image_rounded,
                        color: Colors.grey.shade300,
                        size: 38,
                      )),
            ),
          ),
        )),
        DataCell(
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>EditProduct(productId: document.get('productId'))));
          }, icon: Icon(Icons.info_outline,size: 22,)),
        ),
        DataCell(
          popButton(document.data(), context: context),
        )
      ]);
    }).toList();
    return newList;
  }

  Widget popButton(data, {required BuildContext context}) {

    FireBaseService service=FireBaseService();
    return PopupMenuButton<String>(
        onSelected: (value){
          if(value=='unpublish'){
            service.unPublishedProduct(id: data['productId']);
          }
          if(value=='delete'){
            service.deleteProduct(id: data['productId']);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
              value: 'unpublish',
              child: ListTile(
                leading: Icon(Icons.check),
                title: Text('Un Publish'),
              )),
          PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text('Edit Product'),
              )),
          PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('Delete'),
              )),
        ]);
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtd_vendor/Provider/productProvider.dart';
import 'package:dtd_vendor/Services/firebase_service.dart';
import 'package:dtd_vendor/Widgets/txt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  FireBaseService service = FireBaseService();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, val, child){
        return Dialog(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text("Select Category", Colors.white, FontWeight.w400, 18),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                StreamBuilder(
                    stream: service.category.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot){
                      if(snapshot.hasError){
                        return Text('Something went wrong');
                      }
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Container(
                            child: Center(child: CircularProgressIndicator(),));
                      }
                      return Expanded(
                        child: ListView(
                          children: snapshot.data!.docs.map((DocumentSnapshot document){
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey.shade100,
                                backgroundImage: NetworkImage(
                                    document.get('imageUrl')),
                              ),
                              title: text(document.get('categoryName'), Colors.black45, FontWeight.w400, 16),
                              onTap: (){
                                val.selectCategory(document.get('categoryName'),document.get('imageUrl'));
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                        ),
                      );
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}




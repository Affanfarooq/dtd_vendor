import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtd_vendor/Provider/productProvider.dart';
import 'package:dtd_vendor/Services/firebase_service.dart';
import 'package:dtd_vendor/Widgets/txt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubCategoryList extends StatefulWidget {
  const SubCategoryList({Key? key}) : super(key: key);

  @override
  State<SubCategoryList> createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
  FireBaseService service = FireBaseService();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, val, child) {
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
                        text("Select SubCategory", Colors.white,
                            FontWeight.w400, 18),
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
                FutureBuilder<DocumentSnapshot>(
                    future: service.category.doc(val.selectedCategory).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Expanded(
                            child: Column(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    text("Main Category : ", Colors.black45,
                                        FontWeight.w400, 14),
                                    text(val.selectedCategory!, Colors.black54,
                                        FontWeight.w400, 14),
                                  ],
                                ),
                              ),
                              color: Colors.grey.shade100,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            data['subCat'] == null
                                ? Container(
                                  child: Center(
                                    child: text(
                                        "No sub category found in ${val.selectedCategory}...!",
                                        Colors.black54,
                                        FontWeight.w400,
                                        12),
                                  ),
                              height: MediaQuery.of(context).size.height/2,
                                )
                                : Container(
                                    child: Expanded(
                                      child: ListView.builder(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 15),
                                            leading: CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                                  Colors.grey.shade100,
                                              child: Text(
                                                "${index + 1}",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            title: text(
                                                data['subCat'][index]['name'],
                                                Colors.black87,
                                                FontWeight.w400,
                                                14),
                                            onTap: () {
                                              val.selectSubCategory(
                                                  data['subCat'][index]
                                                      ['name']);
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                        itemCount: data['subCat'] == null
                                            ? 0
                                            : data['subCat'].length,
                                      ),
                                    ),
                                  )
                          ],
                        ));
                      }
                      return Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ));
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}

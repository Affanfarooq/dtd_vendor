import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtd_vendor/Provider/productProvider.dart';
import 'package:dtd_vendor/Services/firebase_service.dart';
import 'package:dtd_vendor/Widgets/category_list.dart';
import 'package:dtd_vendor/Widgets/subCategory_list.dart';
import 'package:dtd_vendor/Widgets/txt.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  final String productId;
  const EditProduct({required this.productId});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  FireBaseService services = FireBaseService();
  final formKey = GlobalKey<FormState>();
  var skuController = TextEditingController();
  var productNameController = TextEditingController();
  var weightController = TextEditingController();
  var priceController = TextEditingController();
  var comparePriceController = TextEditingController();
  var descriptionController = TextEditingController();
  var categoryController = TextEditingController();
  var subCategoryController = TextEditingController();
  var stockController = TextEditingController();
  var lowStockController = TextEditingController();
  var taxController = TextEditingController();

  // double? discount;
  String? image;
  String? categoryImage;
  XFile? _image;
  bool visible = false;
  bool edit=true;

  List<String> collection = [
    'Featured Product',
    'Best Selling',
    'Recently Added',
  ];
  String? dropDownValue;

  DocumentSnapshot? doc;

  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future<void> getProductDetails() async {
    services.products
        .doc(widget.productId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        setState(() {
          doc = document;
          skuController.text = document.get('sku');
          productNameController.text = document.get('productName');
          weightController.text = document.get('weight');
          priceController.text = document.get('price').toString();
          comparePriceController.text = document.get('comparedPrice') != null
              ? document.get('comparedPrice').toString()
              : '';
          image = document.get('productImage');
          descriptionController.text = document.get('description');
          categoryController.text = document['category']['mainCategory'];
          subCategoryController.text = document['category']['subCategory'];
          dropDownValue = document.get('collection')!= null?document.get('collection'):'';
          stockController.text =  document.get('stockQty') != null
              ? document.get('stockQty').toString()
              : '';
          lowStockController.text =
          document.get('lowStock') != null
              ? document.get('lowStock').toString()
              : '';
          taxController.text = document.get('tax %');
          categoryImage=document['category']['categoryImage'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white,elevation: 0),
              onPressed: (){
            setState(() {
              edit=!edit;
            });
          }, icon: Icon(Icons.edit_outlined), label: Text("Edit"))
        ],
      ),
      bottomSheet: Container(
        height:edit==false? 60:0,
        child: edit==false?Row(
          children: [
            Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Colors.black87,
                    child: Center(
                        child: txt('Cancel', 17, FontWeight.w500, Colors.white)),
                  ),
                )),
            Expanded(
                child: InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      if (_image != null) {
                        // EasyLoading.show(status: 'Saving');

                        provider.uploadProductImageToStorage(_image!.path, productNameController.text).then((url){
                          if(url!=null){
                            // EasyLoading.dismiss();
                            provider.updateProductDataToDb(
                              productName:productNameController.text,
                              weight: weightController.text,
                              tax: taxController.text,
                              stockQuantity: stockController.text==''?null:int.parse(stockController.text),
                              sku: skuController.text,
                              price: int.parse(priceController.text),
                              lowQuantity: lowStockController.text==''?null:int.parse(lowStockController.text),
                              description: descriptionController.text,
                              collection: dropDownValue,
                              comparePrice: comparePriceController.text==''?null:int.parse(comparePriceController.text),
                              productId: widget.productId,
                              image: image,
                              category: categoryController.text,
                              subCategory: subCategoryController.text,
                              categoryImage: categoryImage,
                              context: context,
                            );
                          }
                        });
                      }else{
                        provider.updateProductDataToDb(
                          productName:productNameController.text,
                          weight: weightController.text,
                          tax: taxController.text,
                          stockQuantity: stockController.text==''?null:int.parse(stockController.text),
                          sku: skuController.text,
                          price: int.parse(priceController.text),
                          lowQuantity: lowStockController.text==''?null:int.parse(lowStockController.text),
                          description: descriptionController.text,
                          collection: dropDownValue,
                          comparePrice: comparePriceController.text==''?null:int.parse(comparePriceController.text),
                          productId: widget.productId,
                          image: image,
                          category: categoryController.text,
                          subCategory: subCategoryController.text,
                          categoryImage: categoryImage,
                          context: context,
                        );
                        // EasyLoading.dismiss();
                      }
                      provider.resetData();
                    }
                  },
                  child: Container(
                    color: Colors.pink.shade400,
                    child: Center(
                        child: txt('Save', 17, FontWeight.w500, Colors.white)),
                  ),
                )),
          ],
        ):Container(),
      ),
      body: doc == null
          ? Center(child: CircularProgressIndicator())
          : Form(
        key: formKey,
        child: ListView(
          children: [
            AbsorbPointer(
              absorbing: edit,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextFormField(
                              controller: productNameController,
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        comparePriceController.text==''?Container():Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.red.shade400,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                              child: Center(
                                child: txt(
                                    '${((int.parse(comparePriceController.text) -
                                        double.parse(priceController.text)) /
                                        int.parse(comparePriceController.text) *
                                        100).toStringAsFixed(0)}'
                                        ' % OFF',
                                    14,
                                    FontWeight.w500,
                                    Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: txt('Weight', 12, FontWeight.w500, Colors.black38),
                              ),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width/3.3,
                                decoration: BoxDecoration (
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                    color: Colors.grey.shade200
                                ),
                                child: TextFormField(
                                  controller: weightController,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 10,bottom: 10),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: txt('Selling Price', 12, FontWeight.w500, Colors.black38),
                                ),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration (
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      color: Colors.grey.shade200
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: priceController,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.green),
                                    decoration: InputDecoration(
                                      prefixText: 'Rs : ',
                                      prefixStyle: TextStyle(color: Colors.green),
                                      contentPadding: EdgeInsets.only(left: 10,bottom: 5),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10,),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: txt('Compared Price', 12, FontWeight.w500, Colors.black38),
                                ),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration (
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      color: Colors.grey.shade200
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: comparePriceController,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                        decoration: TextDecoration.lineThrough),
                                    decoration: InputDecoration(
                                      hintText: '----',
                                      prefixText: 'Rs : ',
                                      prefixStyle: TextStyle(color: Colors.black54),
                                      contentPadding: EdgeInsets.only(left: 10,bottom: 5),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: _image != null
                            ? Image.file(File(_image!.path))
                            : CachedNetworkImage(
                          imageUrl: image!,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url,
                              downloadProgress) =>
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                child: Center(
                                    child: Icon(
                                      Icons.image_rounded,
                                      color: Colors.grey.shade300,
                                      size: 100,
                                    )),
                              ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        top: 10,
                        child: InkWell(
                          onTap: () {
                            provider.getImage().then((image) {
                              setState(() {
                                _image = image;
                              });
                            });
                          },
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.grey.withOpacity(0.6),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.green.shade300,
                        child:
                        Center(child:
                        Text("About this product",style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700,color: Colors.white,letterSpacing: 3.5),),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft:
                                      Radius.circular(5)),
                                  color: Colors.white,
                                ),
                                height: 78,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10,left: 7),
                                  child: text(
                                      "Description :",
                                      Colors.black54,
                                      FontWeight.w400,
                                      16),
                                )),
                            Expanded(
                              child: TextFormField(
                                controller: descriptionController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.green,
                                      width: 1,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft:
                                      Radius.circular(5)),
                                  color: Colors.white,
                                ),
                                height: 48,
                                child: Center(
                                    child: text(
                                        "  Category * ",
                                        Colors.black54,
                                        FontWeight.w400,
                                        16))),
                            Expanded(
                              child: TextFormField(
                                controller: categoryController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(left: 10),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  enabled: false,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.green,
                                      width: 1,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight:
                                      Radius.circular(5)),
                                  color: Colors.white,
                                ),
                                height: 48,
                                child: Center(
                                    child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext
                                              context) {
                                                return CategoryList();
                                              }).whenComplete((){
                                                setState(() {
                                                  categoryController.text=provider.selectedCategory!;
                                                  visible=true;
                                                });
                                          });
                                        },
                                        icon: Icon(Icons
                                            .arrow_drop_down)))),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Visibility(
                          visible: visible,
                          child: Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft:
                                        Radius.circular(5)),
                                    color: Colors.white,
                                  ),
                                  height: 48,
                                  child: Center(
                                      child: text(
                                          "  Sub Category * ",
                                          Colors.black54,
                                          FontWeight.w400,
                                          16))),
                              Expanded(
                                child: TextFormField(
                                  controller:
                                  subCategoryController,
                                  keyboardType:
                                  TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding:
                                    EdgeInsets.only(left: 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    enabled: false,
                                    focusedBorder:
                                    OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 1,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight:
                                        Radius.circular(5),
                                        bottomRight:
                                        Radius.circular(5)),
                                    color: Colors.white,
                                  ),
                                  height: 48,
                                  child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext
                                                context) {
                                                  return SubCategoryList();
                                                }).whenComplete(() {
                                              setState(() {
                                                subCategoryController.text =
                                                provider.selectedSubCategory!;
                                              });
                                            });
                                          },
                                          icon: Icon(Icons
                                              .arrow_drop_down)))),
                            ],
                          ),
                        ),
                        ClipRRect(
                              borderRadius:
                              BorderRadius.circular(5),
                              child: Row(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft:
                                            Radius.circular(5)),
                                        color: Colors.white,
                                      ),
                                      height: 48,
                                      child: Center(
                                          child: text(
                                              '  Collection ',
                                              Colors.black54,
                                              FontWeight.w400,
                                              16))),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white),
                                      child: DropdownButton<String>(
                                        underline: Container(),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        isExpanded: true,
                                        hint: Text('Select Collection'),
                                        value: dropDownValue,
                                        icon: Icon(Icons.arrow_drop_down),
                                          onChanged: (value) {
                                            setState(() {
                                              dropDownValue = value!;
                                            });
                                          },
                                        items: collection.map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value));
                                            }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft:
                                      Radius.circular(5)),
                                  color: Colors.white,
                                ),
                                height: 48,
                                child: Center(
                                    child: text(
                                        "  Stock : ",
                                        Colors.black54,
                                        FontWeight.w400,
                                        16))),
                            Expanded(
                              child: TextFormField(
                                controller: stockController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(left: 10),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.green,
                                      width: 1,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft:
                                      Radius.circular(5)),
                                  color: Colors.white,
                                ),
                                height: 48,
                                child: Center(
                                    child: text(
                                        "  Low Stock : ",
                                        Colors.black54,
                                        FontWeight.w400,
                                        16))),
                            Expanded(
                              child: TextFormField(
                                controller: lowStockController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(left: 10),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.green,
                                      width: 1,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft:
                                      Radius.circular(5)),
                                  color: Colors.white,
                                ),
                                height: 48,
                                child: Center(
                                    child: text(
                                        "  Tax % : ",
                                        Colors.black54,
                                        FontWeight.w400,
                                        16))),
                            Expanded(
                              child: TextFormField(
                                controller: taxController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(left: 10),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.green,
                                      width: 1,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 70,),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget txt(String text, double size, FontWeight weight, Color color){
    return Text(text, style: TextStyle(fontSize: size, fontWeight: weight, color: color),);
  }
}

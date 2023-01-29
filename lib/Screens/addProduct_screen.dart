import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dtd_vendor/Provider/productProvider.dart';
import 'package:dtd_vendor/Widgets/category_list.dart';
import 'package:dtd_vendor/Widgets/subCategory_list.dart';
import 'package:dtd_vendor/Widgets/txt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  static const String id = 'addProduct-screen';

  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formKey = GlobalKey<FormState>();
  List<String> collection = [
    'Featured Product',
    'Best Selling',
    'Recently Added',
  ];

  @override
  Widget build(BuildContext context){
    print('Afffan farooq 55');
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 4,
        backgroundColor: Colors.green.withOpacity(0.2),
        animationDuration: Duration(milliseconds: 500));
    return Consumer<ProductProvider>(
      builder: (context, val, child){
        return DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 48,
                elevation: 0,
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text("Products / Add", Colors.white,
                                    FontWeight.w400, 18),
                                SizedBox(
                                  width: 100,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green.shade300),
                                          elevation:
                                              MaterialStateProperty.all(0)),
                                      onPressed: () {
                                        if(formKey.currentState!.validate()){
                                          if(val.comparedPrice!>val.sellingPrice!){
                                            if(val.image!=null){
                                              progressDialog.show();
                                              val.uploadProductImageToStorage(val.image!.path, val.productName).then((url){
                                                if(url!=null){
                                                  progressDialog.dismiss();
                                                  val.saveProductDataToDb(
                                                    context: context,
                                                    comparedPrice: val.comparedPrice,
                                                    collection: val.dropDown,
                                                    description: val.aboutProduct,
                                                    lowStock: val.lowStockInventory,
                                                    price: val.sellingPrice,
                                                    sku: val.sku,
                                                    stockQty: val.inventory,
                                                    productName: val.productName,
                                                    weight: val.weight,
                                                    taxPercent: val.tax,
                                                  );
                                                  val.reset(formKey);
                                                }
                                              });
                                            }else{
                                              val.alertDialog(
                                                context: context,
                                                title: 'PRODUCT IMAGE',
                                                content: 'Please select product image',
                                              );
                                            }
                                          }
                                          else{
                                            return val.message('Selling price can\'t be greater than compared price', context);
                                          }
                                        }
                                      },
                                      child: Text(
                                        "Save",
                                        style: TextStyle(
                                            color: Colors.green.shade800,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      )),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    TabBar(
                        indicator: BoxDecoration(color: Colors.green.shade50),
                        indicatorPadding: EdgeInsets.zero,
                        labelStyle: TextStyle(fontWeight: FontWeight.w500),
                        labelColor: Colors.black,
                        overlayColor:
                            MaterialStateProperty.all(Colors.green.shade100),
                        tabs: [
                          Tab(
                            text: 'GENERAL',
                          ),
                          Tab(
                            text: 'INVENTORY',
                          ),
                        ]),
                    Expanded(
                      child: Container(
                        child: TabBarView(children: [
                          ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        val.getImage();
                                      },
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 200,
                                        child: Card(
                                          child: val.image == null
                                              ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .add_photo_alternate_rounded,
                                                      color: Colors.grey.shade300,
                                                      size: 90,
                                                    ),
                                                  text("Product Image", Colors.black38, FontWeight.w500, 11),
                                                ],
                                              )
                                              : Image.file(
                                                  File(val.image!.path)),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        contentPadding:
                                        EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        hintText: 'Product Name *',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.green,
                                            width: 1,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return val.message('Enter product name ...!', context);
                                        }
                                        val.proName(value);
                                        return null;
                                      },
                                      controller: val.productNameController,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    TextFormField(
                                      controller: val.aboutProductController,
                                      validator: (value){
                                        val.abProduct(value);
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                        EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        hintText: 'About Product',
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
                                    SizedBox(
                                      height: 8,
                                    ),
                                    TextFormField(
                                      controller: val.sellingPriceController,
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return val.message('Enter Selling Price ...!', context);
                                        }
                                        val.sellPrice(int.parse(value));
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        hintText: 'Selling Price *',
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
                                    SizedBox(
                                      height: 8,
                                    ),
                                    TextFormField(
                                      controller: val.comparedPriceController,
                                      onChanged: (value){
                                        val.compPrice(int.parse(value));
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder(borderSide: BorderSide.none),
                                        hintText: 'Market Price',
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
                                    SizedBox(
                                      height: 8,
                                    ),
                                    TextFormField(
                                      controller: val.productWeightController,
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return val.message('Enter weight of product ...!', context);
                                        }
                                        val.weightAssign(value);
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        hintText:
                                            'Weight. eg:- kg, gm, L etc *',
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
                                    SizedBox(
                                      height: 8,
                                    ),
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
                                            validator: (value){
                                              if(value!.isEmpty){
                                                return val.message('Select category name ...!', context);
                                              }
                                              return null;
                                            },
                                            controller:
                                                val.categoryTextController,
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
                                                          });
                                                    },
                                                    icon: Icon(Icons
                                                        .arrow_drop_down)))),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Visibility(
                                      visible: val.selectedCategory == null
                                          ? false
                                          : true,
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
                                              validator: (value){
                                                if(value!.isEmpty){
                                                  return val.message('Select sub category name ...!', context);
                                                }
                                                return null;
                                              },
                                              controller:
                                                  val.subCategoryTextController,
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
                                                            });
                                                      },
                                                      icon: Icon(Icons
                                                          .arrow_drop_down)))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Consumer<ProductProvider>(
                                      builder: (context, val, child) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                              value: val.dropDown,
                                              icon: Icon(Icons.arrow_drop_down),
                                              onChanged: (String? value) {
                                                val.dropDownValue(value);
                                              },
                                              items: collection.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem(
                                                    value: value,
                                                    child: Text(value));
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    TextFormField(
                                      controller: val.skuController,
                                      onChanged: (value){
                                        val.skuAssign(value);
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        hintText: 'SKU',
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
                                    SizedBox(
                                      height: 8,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: val.taxController,
                                      onChanged: (value){
                                        val.taxAssign(int.parse(value));
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                        EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        hintText: 'Tax %',
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
                                  ],
                                ),
                              )
                            ],
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 8,),
                                SwitchListTile(
                                    title: Text('Track Inventory'),
                                    activeColor: Colors.green,
                                    subtitle: Text(
                                      'Switch ON to track inventory',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    value: val.track,
                                    onChanged: (value) {
                                      if(val.inventoryController!=null && val.lowStockInventoryController!=null){
                                        val.clear();
                                      }else{
                                        val.trackInventory();
                                      }
                                    }),
                                Visibility(
                                  visible: val.track,
                                  child: SizedBox(
                                    height: 300,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: val.inventoryController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value){
                                              val.inventoryAssign(double.parse(value));
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                              EdgeInsets.only(left: 10),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none),
                                              hintText: 'Inventory Quantity',
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
                                          SizedBox(height: 10,),
                                          TextFormField(
                                            controller: val.lowStockInventoryController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value){
                                              val.lowInventoryAssign(double.parse(value));
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                              EdgeInsets.only(left: 10),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none),
                                              hintText: 'Inventory low stock quantity',
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                             ),
                           ),
                         ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
        );
      },
    );
  }
}
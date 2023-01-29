import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  String? dropDown;
  dropDownValue(value) {
    this.dropDown = value;
    notifyListeners();
  }

  String? selectedCategory;
  var categoryTextController = TextEditingController();
  selectCategory(mainCategory, categoryImg) {
    selectedCategory = mainCategory;
    categoryImage = categoryImg;
    categoryTextController.text = selectedCategory!;
    subCategoryTextController.text = '';
    notifyListeners();
  }

  String? selectedSubCategory;
  var subCategoryTextController = TextEditingController();
  selectSubCategory(selected) {
    selectedSubCategory = selected;
    subCategoryTextController.text = selectedSubCategory!;
    notifyListeners();
  }

  bool visible = false;
  XFile? image;
  String pickedError = '';
  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 15);
    if (pickedFile != null) {
      this.image = XFile(pickedFile.path);
      notifyListeners();
    } else {
      this.pickedError = 'No image selected';
      print('No image selected');
      notifyListeners();
    }
    return image;
  }

  bool track = false;
  trackInventory() {
    track = !track;
    notifyListeners();
  }

  clear() {
    inventory = null;
    lowStockInventory = null;
    inventoryController.clear();
    lowStockInventoryController.clear();
    track = !track;
    notifyListeners();
  }

  final productNameController = TextEditingController();
  final aboutProductController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final comparedPriceController = TextEditingController();
  final productWeightController = TextEditingController();
  final skuController = TextEditingController();
  final inventoryController = TextEditingController();
  final lowStockInventoryController = TextEditingController();
  final taxController = TextEditingController();

  String? productName;
  String? aboutProduct;
  int? sellingPrice;
  int? comparedPrice;
  var weight;
  var sku;
  double? inventory;
  double? lowStockInventory;
  int? tax;
  String productUrl='';

  proName(value) {
    productName = value;
    notifyListeners();
  }

  abProduct(value) {
    aboutProduct = value;
    notifyListeners();
  }

  sellPrice(int value) {
    sellingPrice = value;
    notifyListeners();
  }

  compPrice(int value) {
    comparedPrice = value;
    notifyListeners();
  }

  weightAssign(value) {
    weight = value;
    notifyListeners();
  }

  skuAssign(value) {
    sku = value;
    notifyListeners();
  }

  inventoryAssign(value) {
    inventory = value;
    notifyListeners();
  }

  lowInventoryAssign(value) {
    lowStockInventory = value;
    notifyListeners();
  }

  taxAssign(int value) {
    tax = value;
    notifyListeners();
  }

  message(String message, context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        )));
  }

  alertDialog({context, title, content}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<String> uploadProductImageToStorage(filePath, productName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage
          .ref('Product Images/${this.shopName}/$productName$timeStamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.toString());
    }

    String downLoadURL = await storage
        .ref('Product Images/${this.shopName}/$productName$timeStamp')
        .getDownloadURL();
    this.productUrl=downLoadURL;
    notifyListeners();
    return downLoadURL;
  }

  String shopName = '';
  getShopName(String name) {
    shopName = name;
    notifyListeners();
  }

  String? categoryImage = '';
  Future<void>? saveProductDataToDb({
    context,
    productName,
    description,
    price,
    comparedPrice,
    collection,
    sku,
    weight,
    stockQty,
    lowStock,
    taxPercent,
  }) {
    var timeStamp = DateTime.now().microsecondsSinceEpoch;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference product =
        FirebaseFirestore.instance.collection('Products');
    try {
      product.doc(timeStamp.toString()).set({
        'seller': {'shopName': this.shopName, 'sellerUid': user!.uid},
        'productName': productName,
        'description': description,
        'price': price,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'sku': sku,
        'category': {
          'mainCategory': this.selectedCategory,
          'subCategory': this.selectedSubCategory,
          'categoryImage': this.categoryImage
        },
        'weight': weight,
        'stockQty': stockQty,
        'lowStock': lowStock,
        'published': false,
        'productId': timeStamp.toString(),
        'tax %': taxPercent,
        'productImage': this.productUrl,
      });
      alertDialog(
        context: context,
        title: 'SAVE DATA',
        content: 'Product details saved successfully',
      );
    } catch (e) {
      alertDialog(
        context: context,
        title: 'SAVE DATA',
        content: '${e.toString()}',
      );
    }
    return null;
  }

  reset(GlobalKey<FormState> key){
    key.currentState!.reset();
    image=null;
    track=false;
    visible=false;
    dropDown=null;
    productName=null;
    aboutProduct=null;
    sellingPrice=null;
    comparedPrice=null;
    weight=null;
    sku=null;
    inventory=null;
    lowStockInventory=null;
    tax=null;
    productUrl='';
    selectedCategory=null;
    selectedSubCategory=null;
    productNameController.clear();
    aboutProductController.clear();
    sellingPriceController.clear();
    comparedPriceController.clear();
    productWeightController.clear();
    categoryTextController.clear();
    subCategoryTextController.clear();
    skuController.clear();
    taxController.clear();
    lowStockInventoryController.clear();
    inventoryController.clear();
    notifyListeners();
  }

  updateProductDataToDb(
      {
        productName,
        description,
        price,
        comparePrice,
        collection,
        brand,
        sku,
        weight,
        tax,
        stockQuantity,
        lowQuantity,
        productId,
        image,
        category,
        subCategory,
        categoryImage,
        context
      }) {
    CollectionReference products = FirebaseFirestore.instance.collection('products');
    try {
      products.doc(productId).update({
        'productName': productName,
        'description': description,
        'price': price,
        'comparedPrice': comparePrice,
        'collection': collection,
        'brand': brand,
        'sku': sku,
        'category': {
          'mainCategory': category,
          'subCategory': subCategory,
          'categoryImage': this.categoryImage==null?categoryImage:this.categoryImage,
        },
        'weight': weight,
        'tax': tax,
        'stockQuantity': stockQuantity,
        'lowStockQuantity': lowQuantity,
        'published': false,
        'productImage': this.productUrl==null?image:this.productUrl,
      });
      this.alertDialog(
         context: context,title: 'SAVE DATA',content: 'Product details save Successfully');
    } catch (e) {
      this.alertDialog(context: context,title: 'SAVE DATA',content: '${e.toString()}');
    }
    return null;
  }

  resetData(){
    this.selectedCategory='';
    this.selectedSubCategory='';
    this.productUrl='';
    this.categoryImage='';
    this.image=null;
    notifyListeners();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireBaseService{
  CollectionReference category=FirebaseFirestore.instance.collection('Category');
  CollectionReference products=FirebaseFirestore.instance.collection('Products');

  Future<void> publishedProduct({id}){
    return products.doc(id).update({
      'published':true,
    });
  }

  Future<void> unPublishedProduct({id}){
    return products.doc(id).update({
      'published':false,
    });
  }

  Future<void> deleteProduct({id}){
    return products.doc(id).delete();
  }
}

var vendorData;
var shopImage;


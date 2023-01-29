import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtd_vendor/Services/firebase_service.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  @override
  createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  List<Tab>? tabBars;
  List<Widget>? tabBarViews;
  final tabIconSize = 30.0;
  List<DataRow> productDetail(
      {required QuerySnapshot? snapshot, required BuildContext context}) {
    List<DataRow> newList = snapshot!.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(Container(
            width: 150,
            child: Text(document.get('productName')))),
        DataCell(Container(
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(document.get('productImage')),
          ),
        )),
        DataCell(
          IconButton(onPressed: (){
            // Navigator.push(context, MaterialPageRoute(builder: (_)=>EditProduct(productId: document.get('productId'))));
          }, icon: Icon(Icons.info_outline)),
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
          if(value=='publish'){
            service.publishedProduct(id: data['productId']);
          }
          if(value=='delete'){
            service.deleteProduct(id: data['productId']);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
              value: 'publish',
              child: ListTile(
                leading: Icon(Icons.check),
                title: Text('Publish'),
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
  @override
  void initState() {
    FireBaseService service=FireBaseService();
    controller = new TabController(vsync: this, length: 2);
    controller!.index = 1;
    tabBars = [
      Tab(
        child: Text("PUBLISHED"),
      ),
      Tab(
        child: Text("UN PUBLISHED"),
      ),
    ];
    tabBarViews = [
      Container(
        child: StreamBuilder(
            stream: service.products.where('published', isEqualTo: true).snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot> snapShot) {
              if (snapShot.hasError) {
                return Text('Something went wrong');
              }
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                child: snapShot.data!.docs.length==0?Container(
                  height: MediaQuery.of(context).size.height/1.6,
                  child: Center(
                    child: Text('No product published yet'),
                  ),
                ):FittedBox(
                  child: DataTable(
                    dataRowHeight: 60,
                    columnSpacing: 22,
                    showBottomBorder: true,
                    headingRowColor:
                    MaterialStateProperty.all(Colors.grey.shade200),
                    columns: [
                      DataColumn(
                          label: Expanded(
                              flex: 1,
                              child: Text('Product Name'))),
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('   Info')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: productDetail(
                        snapshot: snapShot.data as QuerySnapshot, context: context),
                  ),
                ),
              );
            }),
      ),
      Container(
        child: StreamBuilder(
            stream: service.products.where('published', isEqualTo: false).snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot> snapShot) {
              if (snapShot.hasError) {
                return Text('Something went wrong');
              }
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                child: snapShot.data!.docs.length==0?Container(
                  height: 100,
                  child: Center(
                    child: Text('No product add'),
                  ),
                ):FittedBox(
                  child: DataTable(
                    dataRowHeight: 60,
                    columnSpacing: 22,
                    showBottomBorder: true,
                    headingRowColor:
                    MaterialStateProperty.all(Colors.grey.shade200),
                    columns: [
                      DataColumn(
                          label: Expanded(
                              flex: 1,
                              child: Text('Product Name'))),
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('   Info')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: productDetail(
                        snapshot: snapShot.data as QuerySnapshot, context: context),
                  ),
                ),
              );
            }),
      ),
    ];

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
          child: TabBar(
        controller: controller,
        tabs: tabBars!,
            indicator: BoxDecoration(color: Colors.green.shade200),
            indicatorPadding: EdgeInsets.zero,
            labelStyle: TextStyle(fontWeight: FontWeight.w500),
            labelColor: Colors.black,
            overlayColor: MaterialStateProperty.all(Colors.green.shade100),
      )),
      body: TabBarView(
        children: tabBarViews!,
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}

class TestScreen1 extends StatefulWidget {
  @override
  createState() => _TestScreen1State();
}

class _TestScreen1State extends State<TestScreen1> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FireBaseService service = FireBaseService();

    return Scaffold(
      body: Container(
        child: StreamBuilder(
            stream: service.products.where('published', isEqualTo: true).snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot> snapShot) {
              if (snapShot.hasError) {
                return Text('Something went wrong');
              }
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                child: snapShot.data!.docs.length==0?Container(
                  height: MediaQuery.of(context).size.height/1.6,
                  child: Center(
                    child: Text('No product published yet'),
                  ),
                ):FittedBox(
                  child: DataTable(
                    dataRowHeight: 60,
                    columnSpacing: 22,
                    showBottomBorder: true,
                    headingRowColor:
                    MaterialStateProperty.all(Colors.grey.shade200),
                    columns: [
                      DataColumn(
                          label: Expanded(
                              flex: 1,
                              child: Text('Product Name'))),
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('   Info')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: productDetail(
                        snapshot: snapShot.data as QuerySnapshot, context: context),
                  ),
                ),
              );
            }),
      ),
    );
  }
  List<DataRow> productDetail(
      {required QuerySnapshot? snapshot, required BuildContext context}) {
    List<DataRow> newList = snapshot!.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(Container(
            width: 150,
            child: Text(document.get('productName')))),
        DataCell(Container(
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(document.get('productImage')),
          ),
        )),
        DataCell(
          IconButton(onPressed: (){
            // Navigator.push(context, MaterialPageRoute(builder: (_)=>EditProduct(productId: document.get('productId'))));
          }, icon: Icon(Icons.info_outline)),
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
            // service.deleteProduct(id: data['productId']);
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

class TestScreen2 extends StatefulWidget {
  @override
  createState() => _TestScreen2State();
}

class _TestScreen2State extends State<TestScreen2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Affan Un Published");
    FireBaseService service = FireBaseService();

    return Scaffold(
      body: Container(
        child: StreamBuilder(
            stream: service.products.where('published', isEqualTo: false).snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot> snapShot) {
              if (snapShot.hasError) {
                return Text('Something went wrong');
              }
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                child: snapShot.data!.docs.length==0?Container(
                  height: 100,
                  child: Center(
                    child: Text('No product add'),
                  ),
                ):FittedBox(
                  child: DataTable(
                    dataRowHeight: 60,
                    columnSpacing: 22,
                    showBottomBorder: true,
                    headingRowColor:
                    MaterialStateProperty.all(Colors.grey.shade200),
                    columns: [
                      DataColumn(
                          label: Expanded(
                              flex: 1,
                              child: Text('Product Name'))),
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('   Info')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: productDetail(
                        snapshot: snapShot.data as QuerySnapshot, context: context),
                  ),
                ),
              );
            }),
      ),
    );
  }
  List<DataRow> productDetail(
      {required QuerySnapshot? snapshot, required BuildContext context}) {
    List<DataRow> newList = snapshot!.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(Container(
            width: 150,
            child: Text(document.get('productName')))),
        DataCell(Container(
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(document.get('productImage')),
          ),
        )),
        DataCell(
          IconButton(onPressed: (){
            // Navigator.push(context, MaterialPageRoute(builder: (_)=>EditProduct(productId: document.get('productId'))));
          }, icon: Icon(Icons.info_outline)),
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
          if(value=='publish'){
            service.publishedProduct(id: data['productId']);
          }
          if(value=='delete'){
            service.deleteProduct(id: data['productId']);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
              value: 'publish',
              child: ListTile(
                leading: Icon(Icons.check),
                title: Text('Publish'),
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

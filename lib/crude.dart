import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Crude extends StatefulWidget {
  const Crude({super.key});
  @override
  State<Crude> createState() => _crude();
}

class _crude extends State<Crude> {
  //CollectionReference is a type of object provided by Firebase Firestore that is used to reference a collection of documents (Documents) within a database
  //When you call FirebaseFirestore.instance, you are calling the primary instance of Firestore that is already configured in the application.
  //"crud" is passed as the group name. If this group already exists in the database, it will be used. If it doesn't exist, it will be created automatically when new data is added to it.
  final CollectionReference myitem =
      FirebaseFirestore.instance.collection("crud");
  // future A data type used to represent values ​​or results that will be available in the future
  // showdialog It is a type of pop-up window that appears over the current user interface, usually used to display messages, enter data, or confirm certain user actions.
  Future<void> create() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return mydialogbox(
              name: "Create a card",
              condation: "create",
              onpressed: () {
                String name = namecontroler.text;
                String postion = poscontroler.text;
                additems(name, postion);
                Navigator.pop(context);
                namecontroler.text = '';
                poscontroler.text = '';
              });
        });
  }

  void additems(String name, String postion) {
    myitem.add({"name": name, "postion": postion});
  }

  Future<void> update(DocumentSnapshot documentsnapshot) async {
    //This line takes the name value stored in the documentsnapshot document that was fetched from the Firestore database.
//This value is then assigned to the text in the TextField controlled by namecontroler.
//In short, the text field is filled with the value of the current name in the database so that the user can modify it.
    namecontroler.text = documentsnapshot['name'];
    poscontroler.text = documentsnapshot['postion'];
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return mydialogbox(
              name: "update your data",
              condation: "Update",
              onpressed: () async {
                String name = namecontroler.text;
                String postion = poscontroler.text;

                await myitem
                    .doc(documentsnapshot.id)
                    .update({'name': name, 'postion': postion});
                namecontroler.text = '';
                poscontroler.text = '';
                Navigator.pop(context);
              });
        });
  }

  Future<void> delete(String productid) async {
    await myitem.doc(productid).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Deleted successfully"),
      backgroundColor: Colors.red,
      duration: Duration(milliseconds: 600),
    ));
  }

  TextEditingController namecontroler = TextEditingController();
  TextEditingController poscontroler = TextEditingController();
  TextEditingController searchcontroler = TextEditingController();

  bool issearchCLICK = false;
  String searchtext = '';
  void onsearchchange(String value) {
    setState(() {
      searchtext = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: issearchCLICK
            ? Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  onChanged: onsearchchange,
                  controller: searchcontroler,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                      hintText: "search...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                ),
              )
            : Text(
                "Firestore",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  issearchCLICK = !issearchCLICK;
                });
              },
              icon: issearchCLICK ? Icon(Icons.close) : Icon(Icons.search))
        ],
      ),
      body: StreamBuilder(
          stream: myitem.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSNAPSHOT) {
            if (streamSNAPSHOT.hasData) {
              final List<DocumentSnapshot> items = streamSNAPSHOT.data!.docs
                  .where((doc) => doc['name']
                      .toLowerCase()
                      .contains(searchtext.toLowerCase()))
                  .toList();
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, Index) {
                  final DocumentSnapshot documentSnapshot = items[Index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(documentSnapshot['name']),
                          subtitle: Text(documentSnapshot['postion']),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () => update(documentSnapshot),
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () =>
                                        delete(documentSnapshot.id),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: create,
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

//The function returns an element of type Dialog, which is a pop-up window that appears above the current screen and allows custom content to be displayed
  Dialog mydialogbox(
          {required String name,
          required String condation,
          //"Callback" means that this function will be passed to be called later when needed, such as when a button is pressed.
          required VoidCallback onpressed}) =>
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Text(
                    name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close))
                ],
              ),
              TextField(
                controller: namecontroler,
                decoration: InputDecoration(
                    labelText: " name",
                    labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    hintText: "enter your name...",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 3.0,
                      ),
                    )),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: poscontroler,
                decoration: InputDecoration(
                    labelText: "postion",
                    labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    hintText: "entar your postion...",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 3.0,
                      ),
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: onpressed,
                child: Text(condation),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      );
}

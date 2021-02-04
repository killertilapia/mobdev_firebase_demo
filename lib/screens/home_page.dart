import 'package:flutter/material.dart';
import 'package:baylo_karon/services/auth.dart';
import 'package:baylo_karon/models/employee_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baylo_karon/provider/auth_provider.dart';

class HomePage extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  HomePage({this.onSignedOut});

  final VoidCallback onSignedOut;

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = Auth();
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _saveDataToFireStore() async{
    EmployeeModel carlModel = EmployeeModel(
      name: "Carl",
      description: "Crush ng Innovuze",
      title: "Senior Web Developer",
      email: "ctanilon@innovuze.com",
      baseSalaryPerHour: 200.00
    );

    CollectionReference empCollection = _db.collection("employee");
    // #1 with Firebase handling the Id generation
    await empCollection.doc().set(carlModel.toFirebase());

    // #1 with generated Id
    var docId = empCollection.doc().id;
    carlModel.id = docId;
    await empCollection.doc(docId).set(carlModel.toFirebase());

    // // #2 without await
    // empCollection.doc().set(carlModel.toFirebase())
    //   .then((value) => print('New Employee Added'))
    //   .catchError((error) => print('Failed to add employee'));
  }

  Future<EmployeeModel> _retrieveFromFireStore() async{
    CollectionReference empCollection = _db.collection("employee");
    empCollection.where("email", isEqualTo: "ctanilon@innovuze.com").get()
      .then((QuerySnapshot snapshot){
        var result = EmployeeModel.fromFirebase(snapshot.docs.first.data());
        print("${result.name} ${result.description}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout', style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text('Send Data to Firestore'),
                  onPressed: _saveDataToFireStore,
                ),
                RaisedButton(
                  child: Text('Get Data from Firestore'),
                  onPressed: _retrieveFromFireStore,
                ),
              ],
            )
        ),
      ),
    );
  }
}

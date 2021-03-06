import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageDemoPage extends StatefulWidget {
  @override
  _StorageDemoPageState createState() => _StorageDemoPageState();
}

class _StorageDemoPageState extends State<StorageDemoPage> {
  List<Asset> images = List<Asset>();
  String _error;

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  // camera upload
  Future<void> GetAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Storage Demo",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  // pick image from disk
  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,

      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });

    for(var imageFile in images){
      String result = await saveImageToFirebase(imageFile);
    }

  }

  Future<String> saveImageToFirebase(Asset asset) async {
    //StorageReference ref = FirebaseStorage().ref().child("my_file_name.jpg");
    StorageReference ref = FirebaseStorage().ref().child(asset.name);

    StorageUploadTask uploadTask = ref.putData(
        (await asset.getByteData()).buffer.asUint8List()
    );

    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future saveImageURLToFirebase(String imagePath) async {
    // save image path to firestore
    // @todo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Storage Demo Page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Center(child: Text('Error: $_error')),
            RaisedButton(
              child: Text("Pick images"),
              onPressed: GetAssets,
            ),
            Expanded(
              child: buildGridView(),
            )
          ],
        ),
      ),
    );
  }
}

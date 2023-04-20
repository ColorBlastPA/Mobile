import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Animation/animation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    Navigator.pop(context);
  }

  Future<void> _showImageSourceDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ajouter une photo :"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Depuis l'appareil photo"),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Depuis le téléphone"),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.deepOrange,
                  Colors.orange,
                  Colors.orangeAccent,
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElementAnimation(0.5,Column(
                    children: [
                      InkWell(
                        onTap: _showImageSourceDialog,
                        child: CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.white,
                          child: _image != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(75),
                                child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          )
                              : const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Kévin Mazure",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {
                              print("je tape sur le stylo");
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ),

                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),

              ),
            )
          ],
        ),
      ),
    );
  }
}

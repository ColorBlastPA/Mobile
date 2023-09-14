import 'dart:convert';
import 'dart:io';

import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/professionnel.dart';
import 'package:color_blast/Model/update_result_pro.dart';
import 'package:color_blast/Model/user_pro.dart';
import 'package:color_blast/Page/details_profile.dart';
import 'package:color_blast/Page/planning_page.dart';
import 'package:color_blast/Page/request_booking_page.dart';
import 'package:color_blast/Page/update_password_page.dart';
import 'package:color_blast/Page/workspace_selection_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


import '../Animation/animation.dart';
import '../Model/client.dart';
import '../Model/update_result_client.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  Client? client;
  Pro? pro;

  @override
  void initState() {
    super.initState();
    if(DataManager().workspaceClient == true){
      this.client = DataManager().client;
    }else{
      this.pro = DataManager().pro?.pro;
    }

  }



  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await uploadImage(_image!, client!.id);
    }
    Navigator.pop(context);
  }


  Future<void> uploadImage(File imageFile, int idClient) async {
    print("idClient"+idClient.toString());
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api-colorblast.current.ovh/api/setAvatarClient/$idClient'),
      );

      print("path"+imageFile.path);
      var image = await http.MultipartFile.fromPath('file', imageFile.path);
      request.files.add(image);

      var response = await request.send();
      if (response.statusCode == 200) {
        print("ça fonctionne");
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> json = jsonDecode(responseBody);
        Client updatedClient = Client.fromJson(json);
        DataManager().client = updatedClient;
        this.client = updatedClient;
      } else {
        print("Code d'erreur HTTP : ${response.statusCode}");
        print("Raison de l'erreur : ${response.reasonPhrase}");

        String responseBody = await response.stream.bytesToString();
        print("Corps de la réponse en cas d'erreur : $responseBody");
      }
    } catch (error) {
      print(error);
    }
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

  void navigateToChildPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileDetails()),
    );

    if (result is UpdateResultClient) {
        setState(() {
          this.client = result.client;
        });
    }else if(result is UpdateResultPro){
      setState(() {
        this.pro = result.pro;
      });
    }
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
                          child: (_image != null)
                              ? ClipOval(
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          )
                              : ((DataManager().workspaceClient == true)
                              ? (client?.avatar != null && client?.avatar != "")
                              ? ClipOval(
                            child: Image.network(
                              client!.avatar!,
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          )
                              : const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          )
                              : (pro?.avatar != null && pro?.avatar != "")
                              ? ClipOval(
                            child: Image.network(
                              pro!.avatar!,
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          )
                              : const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          )),
                        ),


                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DataManager().workspaceClient!
                                ? (client?.firstname ?? "undefined") + " " + (client?.lastname ?? "undefined")
                                : (pro?.firstname ?? "undefined") + " " + (pro?.lastname ?? "undefined"),
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {
                                navigateToChildPage();
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60,),
                        ElementAnimation(1.4, Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(225, 95, 27, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )]
                          ),
                          child: Column(
                            children: <Widget>[


                            ],

                          ),
                        )),
                        //SizedBox(height: 20,),

                        ElementAnimation(1.5,GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PlanningPage()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8), // Espacement entre l'icône et le texte
                              Text(
                                "Votre planning",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ),

                        SizedBox(height: 20,),

                        ElementAnimation(1.5,GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UpdatePasswordPage()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lock_outline,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8), // Espacement entre l'icône et le texte
                              Text(
                                "Changer de mot de passe",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ),
                        SizedBox(height: 20,),
                        ElementAnimation(1.5,GestureDetector(
                          onTap: () {
                            const url = 'https://colorblast.current.ovh/confidentialite'; // Remplacez par l'URL de vos règles de confidentialité
                            launchUrl(url);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.privacy_tip,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8), // Espacement entre l'icône et le texte
                              Text(
                                "Règles de confidentialité",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ),
                          SizedBox(height: 20,),
                        ElementAnimation(1.5,GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RequestBookingPage()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.request_quote,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              DataManager().workspaceClient == true ?
                              Text(
                                "Suivi des demandes",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                                  :
                              Text(
                                "Demande de devis",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ),
                        SizedBox(height: 20,),
                        ElementAnimation(1.5,GestureDetector(
                          onTap: () {
                            DataManager().reset();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WorkspaceSelectionPage()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.red,

                              ),
                              SizedBox(width: 8), // Espacement entre l'icône et le texte
                              Text(
                                "Déconnexion",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ),
                          Container(
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> launchUrl(String url) async {
  //if (await canLaunch(url)) {
    await launch(url);
  //}
}

import 'package:color_blast/Page/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Animation/animation.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails du profil"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepOrange,
                Colors.orange,
                Colors.orangeAccent,
              ],
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check), // icone "Valider"
            onPressed: () {
              print("je modifie");
            },
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                //SizedBox(height: 20,),
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
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey))
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Prénom",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey))
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Nom",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey))
                        ),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey))
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Pays",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey))
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Département",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey))
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Code postal",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey))
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Ville",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            //border: Border(bottom: BorderSide(color: Colors.grey))
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Adresse",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none
                          ),
                        ),
                      ),

                    ],

                  ),
                ),
                ),
                /*SizedBox(height: 40,),
                ElementAnimation(1.6,GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.orange[900]
                    ),
                    child: Center(
                      child: Text("Modifier", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ),
                )),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

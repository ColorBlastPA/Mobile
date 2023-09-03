import 'package:color_blast/Page/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Animation/animation.dart';
import '../Model/client.dart';
import '../Model/data_manager.dart';
import '../Model/update_result_client.dart';
import '../Service/service_client.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  Client? client = DataManager().client;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = client?.firstname ?? "";
    lastNameController.text = client?.lastname ?? "";
    emailController.text = client?.mail ?? "";
    countryController.text = client?.country ?? "";
    departmentController.text = client?.department ?? "";
    postalCodeController.text = client?.postalCode ?? "";
    cityController.text = client?.city ?? "";
    addressController.text = client?.address ?? "";
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    countryController.dispose();
    departmentController.dispose();
    postalCodeController.dispose();
    cityController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> updateClient() async {
    Client client = Client(lastname: lastNameController.text, firstname: firstNameController.text, mail: emailController.text, password: this.client?.password ?? "", country: countryController.text, department: departmentController.text, postalCode: postalCodeController.text, city: cityController.text, address: addressController.text, id: this.client!.id, avatar: '' );
    print(client.id);

    var response = await ServiceClient().updateClient(client);
    if (response == 200) {
      UpdateResultClient result = UpdateResultClient(context, client);
      Navigator.of(context).pop(result);
    } else {
      print("erreur");
    }
  }


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
            icon: Icon(Icons.check),
            onPressed: () {
              updateClient();
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
                          controller: firstNameController,
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
                          controller: lastNameController,
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
                          controller: emailController,
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
                          controller: countryController,
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
                          controller: departmentController,
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
                          controller: postalCodeController,
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
                          controller: cityController,
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
                          controller: addressController,
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

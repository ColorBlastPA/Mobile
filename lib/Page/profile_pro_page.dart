import 'package:color_blast/Model/professionnel.dart';
import 'package:color_blast/Model/update_result_pro.dart';
import 'package:color_blast/Model/user_pro.dart';
import 'package:color_blast/Service/service_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Animation/animation.dart';
import '../Model/data_manager.dart';

class ProfileProPage extends StatefulWidget {
  const ProfileProPage({Key? key}) : super(key: key);

  @override
  State<ProfileProPage> createState() => _ProfileProPageState();
}

class _ProfileProPageState extends State<ProfileProPage> {

  UserPro? pro = DataManager().pro;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController nameCompanyController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController DescriptionController = TextEditingController();

  bool isPhoneValid = true;
  RegExp phoneRegex = RegExp(r'^0[1-9]\d{8}$');


  @override
  void initState() {
    super.initState();
    firstNameController.text = pro?.pro.firstname ?? "";
    lastNameController.text = pro?.pro.lastname ?? "";
    emailController.text = pro?.pro.mail ?? "";
    countryController.text = pro?.pro.country ?? "";
    departmentController.text = pro?.pro.department ?? "";
    postalCodeController.text = pro?.pro.postalCode ?? "";
    cityController.text = pro?.pro.city ?? "";
    nameCompanyController.text = pro?.pro.companyName ?? "";
    telController.text = pro?.pro.phone.toString() ?? "";
    priceController.text = pro?.pro.price.toString() ?? "";
    DescriptionController.text = pro?.pro.description ?? "";

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
    nameCompanyController.dispose();
    telController.dispose();
    priceController.dispose();
    DescriptionController.dispose();

    super.dispose();
  }

  Future<void> updatePro() async {
    Pro newPro = Pro(id: pro!.pro.id, lastname: lastNameController.text, firstname: firstNameController.text, mail: emailController.text, password: pro?.pro.password ?? "", country: countryController.text, department: departmentController.text, postalCode: postalCodeController.text, city: cityController.text, companyName: nameCompanyController.text, price: double.tryParse(priceController.text) ?? 0, phone: telController.text, note: 0, description: DescriptionController.text, idCertificate: pro?.pro.idCertificate ?? 0, avatar: pro?.pro.avatar ?? "" );

    var response = await ServicePro().updatePro(newPro);
    if (response == 200) {
      if(isPhoneValid == true){
        UpdateResultPro result = UpdateResultPro(context, newPro);
        Navigator.of(context).pop(result);
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Erreur"),
              content: Text("Mauvais format du numéro de téléphone"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }

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
              updatePro();
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
                          border: Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        child: TextField(
                          controller: nameCompanyController,
                          decoration: InputDecoration(
                            hintText: "Nom de la compagnie",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        child: TextField(
                          controller: telController,
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            setState(() {
                              isPhoneValid = phoneRegex.hasMatch(value);
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Numéro de tel",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            errorText: isPhoneValid ? null : 'Numéro invalide',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        child: TextField(
                          controller: priceController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: "Prix moy/H",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          controller: DescriptionController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Description",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                    ],

                  ),
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:color_blast/Model/professionnel.dart';
import 'package:color_blast/Service/service_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Animation/animation.dart';
import '../Model/data_manager.dart';
import 'login_page.dart';

class SignupPage3 extends StatefulWidget {

  const SignupPage3(this.pro);
  final Professionnel pro;

  @override
  State<SignupPage3> createState() => _SignupPage3State(this.pro);
}

class _SignupPage3State extends State<SignupPage3> {
  Professionnel? pro;
  _SignupPage3State(Professionnel pro){
    this.pro = pro;
  }

  final TextEditingController textNameCompanyController = TextEditingController();
  final TextEditingController textTelController = TextEditingController();
  final TextEditingController textPriceController = TextEditingController();
  final TextEditingController textDescriptionController = TextEditingController();
  bool isPhoneValid = true;
  RegExp phoneRegex = RegExp(r'^0[1-9]\d{8}$');


  Future<void> createAccount() async {
    Professionnel newPro = Professionnel(id: 1, lastname: this.pro!.lastname, firstname: this.pro!.firstname, mail: this.pro!.mail, password: this.pro!.password, country: this.pro!.country, department: this.pro!.department, postalCode: this.pro!.postalCode, city: this.pro!.city, companyName: textNameCompanyController.text, price: double.tryParse(textPriceController.text) ?? 0, phone: textTelController.text, note: 0, description: textDescriptionController.text);
    var response = await ServicePro().createPro(newPro);
    if(response == 200){
      Navigator.push(context,
          MaterialPageRoute<void>(
              builder:(BuildContext context) {
                return LoginPage(WorkspaceClient: false,);
              }));
    }else{
      print("erreur");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.deepOrange,
                  Colors.orange,
                  Colors.orangeAccent,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 80,),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ElementAnimation(1, Text(
                        "Création Service",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 60,),
                            ElementAnimation(1.4, Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  )
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey)),
                                    ),
                                    child: TextField(
                                      controller: textNameCompanyController,
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
                                      controller: textTelController,
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
                                        errorText: isPhoneValid
                                            ? null
                                            : 'Numéro invalide',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey)),
                                    ),
                                    child: TextField(
                                      controller: textPriceController,
                                      keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows float input
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
                                      controller: textDescriptionController,
                                      maxLines: 5, // Allows for multiline input
                                      decoration: InputDecoration(
                                        hintText: "Description",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            SizedBox(height: 40,),
                            ElementAnimation(1.6, GestureDetector(
                              onTap: () {
                                createAccount();
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.orange[900],
                                ),
                                child: Center(
                                  child: Text(
                                    "Valider",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )) ,

                            SizedBox(height: 30,),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }


}

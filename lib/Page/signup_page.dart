import 'package:color_blast/Page/signup_page2.dart';
import 'package:color_blast/Service/service_client.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import '../Animation/animation.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool isEmailValid = true;
  TextEditingController passwordController = TextEditingController();
  bool isPasswordValid = true;

  Future<void> nextPage() async {

    int response = await ServiceClient().checkEmail(emailController.text);
    if(response == 200){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Information"),
            content: Text("Ce mail possède déjà un compte."),
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
    }else{
      if(emailController.text.isEmpty || firstnameController.text.isEmpty || lastnameController.text.isEmpty || passwordController.text.isEmpty || isEmailValid == false || isPasswordValid == false){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Information"),
              content: Text("Tous les champs doivent être remplis et valide !"),
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
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignupPage2(firstnameController.text,lastnameController.text,emailController.text,passwordController.text)),
        );
      }
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
                        "Inscription",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )),
                      SizedBox(height: 10,),
                      ElementAnimation(1.3, Text(
                        "Etape 1/2",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                    ],
                  ),
                ),
                SizedBox(height: 20),
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
                                      controller: lastnameController,
                                      decoration: InputDecoration(
                                        hintText: "Nom",
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
                                      controller: firstnameController,
                                      decoration: InputDecoration(
                                        hintText: "Prénom",
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
                                      controller: emailController,
                                      onChanged: (value) {
                                        setState(() {
                                          isEmailValid = emailRegex.hasMatch(value);
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Email",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                        errorText: isEmailValid ? null : "Email invalide",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      //border: Border(bottom: BorderSide(color: Colors.grey))
                                    ),
                                    child: TextField(
                                      controller: passwordController,
                                      onChanged: (value) {
                                        setState(() {
                                          isPasswordValid = value.length >= 8 && value.contains(RegExp(r'[A-Z]'));
                                        });
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: "Mot de passe",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                        errorText: isPasswordValid ? null : "Mot de passe invalide",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            SizedBox(height: 40,),
                            ElementAnimation(1.6, GestureDetector(
                              onTap: () {
                                nextPage();
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
                                    "Suivant",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )),
                            SizedBox(height: 50,),
                            SizedBox(height: 30,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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

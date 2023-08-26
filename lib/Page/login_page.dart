import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Page/forgot_password_page.dart';
import 'package:color_blast/Page/home_page.dart';
import 'package:color_blast/Page/navigation_page.dart';
import 'package:color_blast/Page/navigation_pro_page.dart';
import 'package:color_blast/Page/signup_page.dart';
import 'package:color_blast/Page/workspace_selection_page.dart';
import 'package:color_blast/Service/service_pro.dart';
import 'package:flutter/material.dart';

import '../Animation/animation.dart';
import '../Service/service_client.dart';


class LoginPage extends StatefulWidget {
  final bool WorkspaceClient;

  LoginPage({this.WorkspaceClient = false});

  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {


  void login() async {
    var response = await ServiceClient().login(mailController.text, passwordController.text,widget.WorkspaceClient);
    if (response == 200) {
      DataManager().workspaceClient = widget.WorkspaceClient;
      if(widget.WorkspaceClient == true){
        DataManager().favoris = await ServicePro().getProFavorisById(DataManager().client?.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavigationPage()),
        );
        print(DataManager().client?.mail);
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavigationProPage()),
        );
      }

    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Information"),
            content: Text("Ce compte ou ce mot de passe n'existe pas"),

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
  }

  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  
  @override
  Widget build(BuildContext context) {
    bool isFromNavigationPage = widget.WorkspaceClient;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40, left: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WorkspaceSelectionPage()),
                  );
                },
                child: ElementAnimation(1, Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ElementAnimation(1, Text("Connexion", style: TextStyle(color: Colors.white, fontSize: 40),)),
                  SizedBox(height: 10,),
                  ElementAnimation(1.3, Text("Bienvenue", style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            SizedBox(height: 20),
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
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey))
                                ),
                                child: TextField(
                                  controller: mailController,
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
                                    //border: Border(bottom: BorderSide(color: Colors.grey))
                                ),
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: "Mot de passe",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                            ],

                          ),
                        )),
                        SizedBox(height: 40,),
                        ElementAnimation(1.5,GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ForgotPasswordPage(isFromNavigationPage)),
                              );
                            },
                            child:Text("Mot de passe oublié ?", style: TextStyle(color: Colors.grey),)),
                        ),
                          SizedBox(height: 10,),
                        ElementAnimation(1.5, GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignupPage()),
                            );
                          },
                          child: Text("Vous n'avez pas de compte ?", style: TextStyle(color: Colors.grey)),
                        )),
                        SizedBox(height: 40,),
                        ElementAnimation(1.6,GestureDetector(
                          onTap: () {
                            login();
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NavigationPage()),
                            );*/
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.orange[900]
                            ),
                            child: Center(
                              child: Text("Valider", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        )),
                        SizedBox(height: 50,),
                        //FadeAnimation(1.7, Text("Continue with social media", style: TextStyle(color: Colors.grey),)),
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
    );
  }
}

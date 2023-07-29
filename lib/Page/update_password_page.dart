import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Page/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Animation/animation.dart';
import '../Service/service_client.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  bool isOldPasswordValid = true;
  bool isNewPasswordValid = true;

  Future<void> updatePassword() async{
    print(isOldPasswordValid);
    print(isNewPasswordValid);
    if(isOldPasswordValid == false || isNewPasswordValid == false || oldPasswordController.text.isEmpty || newPasswordController.text.isEmpty){
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
      DataManager().client?.password = newPasswordController.text;
      var response = await ServiceClient().updateClient(DataManager().client!);
      if (response == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Information"),
              content: Text("Votre mot de passe a bien été modifié !"),
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
        setState(() {
          newPasswordController.text = "";
          oldPasswordController.text = "";
        });


      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Information"),
              content: Text("Une erreur est survenu, veuillez réessayer"),
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
        DataManager().client?.password = oldPasswordController.text;
      }
    }




  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Changement du mot de passe"),
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
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(50),
            child: Column(
              children: <Widget>[
                SizedBox(height: 150,),
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
                          controller: oldPasswordController,
                          onChanged: (value) {
                            setState(() {
                              isOldPasswordValid = value == DataManager().client?.password;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Mot de passe actuel",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              errorText: isOldPasswordValid ? null : "Mot de passe invalide",
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            //border: Border(bottom: BorderSide(color: Colors.grey))
                        ),
                        child: TextField(
                          controller: newPasswordController,
                          onChanged: (value) {
                            setState(() {
                              isNewPasswordValid = value.length >= 8 && value.contains(RegExp(r'[A-Z]'));
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Nouveau mot de passe",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              errorText: isNewPasswordValid ? null : "Mot de passe invalide",
                          ),
                        ),
                      ),
                    ],

                  ),
                ),
                ),
                SizedBox(height: 40,),
                ElementAnimation(1.6,GestureDetector(
                  onTap: () {
                    updatePassword();
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
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

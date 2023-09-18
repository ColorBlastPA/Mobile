import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Service/service_email.dart';
import 'package:flutter/material.dart';

import '../Animation/animation.dart';
import '../Model/help.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {

  final TextEditingController textEditingController = TextEditingController();

  Future<void> sendMail() async {
    if(DataManager().workspaceClient == true){
      Help help = Help(mail: DataManager().client!.mail, content: textEditingController.text);
      var response = await ServiceEmail().sendHelpMail(help);
      if(response == 200){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Information"),
              content: Text("Votre mail à bien été envoyer."),

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
        Navigator.of(context).pop();
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Information"),
              content: Text("Une erreur est survenu, veuillez rééssayer"),

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
    }else{
      Help help = Help(mail: DataManager().pro!.pro.mail, content: textEditingController.text);
      var response = await ServiceEmail().sendHelpMail(help);
      if(response == 200){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Information"),
              content: Text("Votre mail à bien été envoyer."),

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
        Navigator.of(context).pop();
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Information"),
              content: Text("Une erreur est survenu, veuillez rééssayer"),

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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aide"),
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElementAnimation(0.6,
          Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            const Text(
              "En cas de problème, veuillez nous envoyer un message. Nous vous répondrons dans les plus brefs délais.",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 150.0),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: "Écrivez votre message ici...",
              ),
              maxLines: null,
            ),
            SizedBox(height: 100.0), // Espacement entre le champ texte et le bouton
            GestureDetector(
              onTap: () {
                sendMail();
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
            ),
          ],
        ),),
      ),
    );
  }


}


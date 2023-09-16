import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/messagerie.dart';
import 'package:color_blast/Page/chat_page.dart';
import 'package:color_blast/Page/shop_page.dart';
import 'package:color_blast/Page/workspace_selection_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Service/service_messagerie.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {

  List<MessagerieClient?>? discussions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();

  }

  getData() async {
    discussions = await ServiceMessagerie().getMessageriesByIdClient(DataManager().client?.id);
    setState(() {
      isLoading = false;
    });
  }

  _afficherDialogueDeconnexion(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Voulez-vous vous déconnecter ?"),
          actions: <Widget>[
            TextButton(
              child: Text("Non"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Oui"),
              onPressed: () {
                DataManager().reset();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkspaceSelectionPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Messagerie"),
        centerTitle: true,
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
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          :discussions == null || discussions == []
          ? Center(
        child: Text("Vous n'avez aucune discussion"),
      )
          : ListView.builder(
        itemCount: discussions?.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              _openChatPage(discussions![index]!);
            },
            child: ListTile(
              leading: CircleAvatar(
                child: Text(getInitials(
                    (discussions?[index]?.pro.lastname ?? "") + " " + (discussions?[index]?.pro.firstname ?? "")
                )),
              ),



              title: Text("${discussions?[index]?.pro.lastname} ${discussions?[index]?.pro.firstname}"),
              subtitle: Text("${discussions?[index]?.messagerie.lastMessage}"),
              trailing: Text(
                formatLastMessageDate(discussions?[index]?.messagerie.dLastMessage),
              ),

            ),
          );
        },
      ),
    ),
        onWillPop:() async{
          await _afficherDialogueDeconnexion(context);
          return false;
        });
  }

  void _openChatPage(MessagerieClient messagerie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(messagerie.messagerie.id)),
    );
  }

  String getInitials(String? name) {
    if (name == null || name.isEmpty) {
      return "";
    }

    List<String> names = name.split(" ");
    String initials = "";

    for (String n in names) {
      if (n.isNotEmpty) {
        initials += n[0];
      }
    }

    return initials;
  }

  String formatLastMessageDate(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime).inDays;

    if (difference == 0) {
      // La date est aujourd'hui, afficher l'heure
      return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
    } else {
      // Afficher la date complète
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    }
  }


}


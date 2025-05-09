import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Page/workspace_selection_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/messaging_pro.dart';
import '../Service/service_messagerie.dart';
import 'chat_page.dart';

class MessagingProPage extends StatefulWidget {
  const MessagingProPage({Key? key}) : super(key: key);

  @override
  State<MessagingProPage> createState() => _MessagingProPageState();
}

class _MessagingProPageState extends State<MessagingProPage> {
  List<MessagingPro?>? discussions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();

  }

  void refreshData() {
    getData();
  }

  getData() async {
    discussions = await ServiceMessagerie().getMessageriesByIdPro(DataManager().pro?.pro.id);
    discussions?.sort((a, b) => b!.messagerie.dLastMessage.compareTo(a!.messagerie.dLastMessage));

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
        child:Scaffold(
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
                        (discussions?[index]?.client.lastname ?? "") + " " + (discussions?[index]?.client.firstname ?? "")
                    )),
                  ),



                  title: Text("${discussions?[index]?.client.lastname} ${discussions?[index]?.client.firstname}"),
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

  void _openChatPage(MessagingPro messagerie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(messagerie.messagerie.id,refreshData, messagerie.client.mail)),
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


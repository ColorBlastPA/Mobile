import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/messagerie.dart';
import 'package:color_blast/Page/chat_page.dart';
import 'package:color_blast/Page/shop_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Service/service_messagerie.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {

  List<Messagerie?>? discussions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //getData();

  }

  getData() async {
    discussions = await ServiceMessagerie().getMessageriesByIdClient(DataManager().client?.id);
    /*setState(() {
      isLoading = false;
    });*/
  }


  // Exemple de données de discussion
  List<Conversation> conversations = [
    Conversation("John Doe", "je suis le dernier message", "2023-06-18"),
    Conversation("Jane Smith", "je suis le dernier message", "2023-06-19"),
    Conversation("Alice Johnson", "je suis le dernier message", "2023-06-20"),
    Conversation("Bob Williams", "je suis le dernier message", "2023-06-20"),
    Conversation("Eve Davis", "je suis le dernier message", "2023-06-20"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: discussions == null || discussions == []
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
                  child: Text(conversations[index].getInitials()),
                ),
                title: Text("${conversations[index].name}"),
                subtitle: Text("${conversations[index].lastMessage}"),
                trailing: Text("${conversations[index].date}"),
            ),
          );
        },
      ),
    );
  }

  void _openChatPage(Messagerie messagerie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(messagerie.id)),
    );
  }
}

class Conversation {
  final String name;
  final String lastMessage;
  final String date;

  Conversation(this.name, this.lastMessage, this.date);

  String getInitials() {
    // Méthode pour obtenir les initiales du nom et prénom
    List<String> names = name.split(" ");
    String initials = "";
    for (var name in names) {
      initials += name[0];
    }
    return initials;
  }
}

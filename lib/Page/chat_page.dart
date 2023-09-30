import 'dart:convert';

import 'package:color_blast/Animation/animation.dart';
import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Service/service_email.dart';
import 'package:color_blast/Service/service_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../Model/line.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(this.idMessagerie,this.refreshCallback,this.mail);
  final Function refreshCallback;

  final int idMessagerie;
  final String mail;
  @override
  State<ChatPage> createState() => _ChatPageState(this.idMessagerie, this.mail);
}


class _ChatPageState extends State<ChatPage> {
  int idMessagerie = 0;
  String mail = "";
  List<Line?>? lines;
  bool isLoading = true;
  Function? unsubscribeFn;
  late StompClient stompClient;
  _ChatPageState(int idMessagerie, String mail){
    this.mail = mail;
    this.idMessagerie = idMessagerie;
  }

  @override
  void initState() {
    super.initState();
    getData();
    stompClient = StompClient(
      config: StompConfig(
        url: 'wss://api-colorblast.current.ovh/websocket-endpoint',
        onConnect: onConnectCallback,
      ),
    );
    stompClient.activate();

  }

  @override
  void dispose() {
    stompClient.deactivate();
    _someMethodThatUpdatesData();
    super.dispose();
  }

  void _someMethodThatUpdatesData() {
    widget.refreshCallback();

  }

  void onConnectCallback(StompFrame frame) {
    print('Connecté au serveur WebSocket STOMP');
    subscribeToChannel(idMessagerie);
  }

  Function? subscribeToChannel(int channelId) {
    // Désabonnez-vous du canal précédent (s'il y en a un)
    if (unsubscribeFn != null) {
      unsubscribeFn!(unsubscribeHeaders: <String, String>{});
    }

    // Abonnez-vous au nouveau canal
    unsubscribeFn = stompClient.subscribe(
      destination: '/topic/chatroom/$channelId',
      callback: (StompFrame frame) {
        final lineEntity = Line.fromJson(jsonDecode(frame.body ?? ""));
        setState(() {
          lines?.add(lineEntity);
          checkDateLastMessage();
        });
      },
    );

    return unsubscribeFn;
  }

  Future<void> checkDateLastMessage() async {
    if (lines != null && lines!.length >= 2) {
      DateTime now = DateTime.now();
      DateTime previousLineDate = lines![lines!.length - 2]?.date ?? now; // L'avant-dernière ligne
      Duration difference = now.difference(previousLineDate);

      if (difference.inHours >= 24) {
        if(DataManager().workspaceClient == true){
          await ServiceEmail().getMessageForProEmail(mail, DataManager().client?.id);
        }else{
          await ServiceEmail().getMessageForClientEmail(mail, DataManager().pro?.pro.id);
        }
      }
    }
  }


  void _sendMessage(Line newLine) {

      final lineEntity = LineEntity(
        idMessagerie: newLine.idMessagerie,
        content: newLine.content,
        mail: newLine.mail,
        lastname: newLine.lastname,
        firstname: newLine.firstname,
        date: newLine.date.toIso8601String(),
      );
      stompClient.send(
        destination: '/app/chat/sendMessage/$idMessagerie',
        body: jsonEncode(lineEntity.toJson()),
      );

  }

  getData() async {
    lines = await ServiceLine().getLinesByIdMessagerie(idMessagerie);
    setState(() {
      isLoading = false;
    });
  }

  void appendLine(Line newLine) async{
    var response = await ServiceLine().appendLine(newLine);
  }


  TextEditingController _textEditingController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discussion"),
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

      body: ElementAnimation(
        0.5,
        Column(
          children: [
            Expanded(
              child: isLoading
                  ? Center(
                    child: CircularProgressIndicator(),
              )
                  : lines != null && lines!.isNotEmpty
                  ? ListView.builder(
                reverse: true,
                itemCount: lines!.length,
                itemBuilder: (BuildContext context, int index) {
                  int invertedIndex = lines!.length - 1 - index;
                  return buildMessageItem(lines![invertedIndex]!);
                },
              )
                  : Center(
                    child: Text("Pas de messages"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: "Saisissez votre message...",
                      ),
                    ),
                  ),
                  CupertinoButton(
                    child: Icon(CupertinoIcons.arrow_right),
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessageItem(Line line) {
    bool isMe = false;
    if (DataManager().workspaceClient == true) {
      isMe = line.mail == DataManager().client?.mail;
    } else {
      isMe = line.mail == DataManager().pro?.pro.mail;
    }

    // Vérifiez si le champ mail est null ou vide
    bool isMessageOnly = line.mail == null || line.mail == "";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: isMessageOnly
          ? Align(
        alignment: Alignment.center,
        child: Text(
          utf8.decode(line.content.runes.toList()),
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12.0, // Taille de police plus petite
          ),
        ),
      )
          : Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${line.firstname} ${line.lastname}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              line.content,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              formatMessageDate(line.date),
              style: TextStyle(color: isMe ? Colors.white70 : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }




  String formatMessageDate(DateTime dateTime) {
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


  void sendMessage() {
    if(DataManager().workspaceClient == true){
      if (_textEditingController.text.isNotEmpty) {
        setState(() {
          String content = _textEditingController.text;
          DateTime date = DateTime.now();
          Line newLine = Line(id: 1, idMessagerie: idMessagerie, lastname: DataManager().client!.lastname, firstname: DataManager().client!.firstname, content: content, date: date, mail:DataManager().client!.mail );
          //lines?.add(newLine);
          _sendMessage(newLine);
          _textEditingController.clear();
        });
      }
    }else{
      if (_textEditingController.text.isNotEmpty) {
        setState(() {
          String content = _textEditingController.text;
          DateTime date = DateTime.now();
          Line newLine = Line(id: 1, idMessagerie: idMessagerie, lastname: DataManager().pro!.pro.lastname, firstname: DataManager().pro!.pro.firstname, content: content, date: date, mail:DataManager().pro!.pro.mail );

          _sendMessage(newLine);
          _textEditingController.clear();
        });
      }
    }

  }

}
//lines?.add(newLine);
class LineEntity {
  int idMessagerie;
  final String content;
  final String? mail;
  final String lastname;
  final String firstname;
  final String date;

  LineEntity({
    required this.idMessagerie,
    required this.content,
    required this.mail,
    required this.lastname,
    required this.firstname,
    required this.date,
  });



  Map<String, dynamic> toJson() {
    return {
      "idMessagerie": idMessagerie,
      'content': content,
      'mail': mail,
      'lastname': lastname,
      'firstname': firstname,
      'date': date,
    };
  }
}





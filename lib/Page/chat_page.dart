import 'package:color_blast/Animation/animation.dart';
import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Service/service_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Model/line.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(this.idMessagerie);

  final int idMessagerie;
  @override
  State<ChatPage> createState() => _ChatPageState(this.idMessagerie);
}


class _ChatPageState extends State<ChatPage> {
  int idMessagerie = 0;
  List<Line?>? lines;
  bool isLoading = true;
  _ChatPageState(int idMessagerie){
    this.idMessagerie = idMessagerie;
  }

  @override
  void initState() {
    super.initState();
    getData();

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
    bool isMe = line.mail == DataManager().client?.mail;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              line.firstname,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            Text(
              line.lastname,
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
              line.date.toString(),
              style: TextStyle(color: isMe ? Colors.white70 : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        String content = _textEditingController.text;
        DateTime date = DateTime.now();
        Line newLine = Line(id: 1, idMessagerie: idMessagerie, lastname: DataManager().client!.lastname, firstname: DataManager().client!.firstname, content: content, date: date, mail:DataManager().client!.mail );
        lines?.add(newLine);
        appendLine(newLine);
        _textEditingController.clear();
      });
    }
  }


}





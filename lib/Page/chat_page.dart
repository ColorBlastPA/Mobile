import 'package:color_blast/Animation/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [
    Message("John Doe", "Salut!", "2023-06-18"),
    Message("Moi", "Bonjour!", "2023-06-18"),
    Message("John Doe", "Salut!", "2023-06-18"),
    Message("Moi", "Bonjour!", "2023-06-18"),
    Message("John Doe", "Salut!", "2023-06-18"),
    Message("Moi", "Bonjour!", "2023-06-18"),
    Message("John Doe", "Salut!", "2023-06-18"),
    Message("Moi", "Bonjour!", "2023-06-18"),
    Message("John Doe", "Salut!", "2023-06-18"),
    Message("Moi", "Bonjour!", "2023-06-18"),
  ];

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
      body: ElementAnimation(0.5,Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Affiche les nouveaux messages en bas
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                // Inverse l'index pour afficher les nouveaux messages en bas
                int invertedIndex = messages.length - 1 - index;
                return buildMessageItem(messages[invertedIndex]);
              },
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

  Widget buildMessageItem(Message message) {
    bool isMe = message.sender == "Moi";
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
              message.sender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              message.content,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              message.date,
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
        String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
        Message newMessage = Message("Moi", content, date);
        messages.add(newMessage);
        _textEditingController.clear();
      });
    }
  }
}

class Message {
  final String sender;
  final String content;
  final String date;

  Message(this.sender, this.content, this.date);
}



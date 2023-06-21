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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(messages[index].getInitials()),
                  ),
                  title: Text(messages[index].content),
                  trailing: Text(messages[index].date),
                );
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

  String getInitials() {
    List<String> names = sender.split(" ");
    String initials = "";
    for (var name in names) {
      initials += name[0];
    }
    return initials;
  }
}

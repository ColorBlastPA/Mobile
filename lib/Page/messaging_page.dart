import 'package:flutter/cupertino.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Messagerie"),
    );
  }
}

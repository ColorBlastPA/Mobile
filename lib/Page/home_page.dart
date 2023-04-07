import 'package:color_blast/Page/service_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.deepOrange,
                  Colors.orange,
                  Colors.orangeAccent,],
              ),
            ),
          ),
          bottom: TabBar(tabs:[
            Tab(
              text: "Services",
            ),
            Tab(
              text: "Favoris",
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            ServiceListPage(),
            Container(
              child: Text("Test2"),
            ),
          ],
        )
    ),
    );
  }
}

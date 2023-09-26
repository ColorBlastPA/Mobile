import 'package:color_blast/Animation/animation.dart';
import 'package:color_blast/Page/take_meet_page.dart';
import 'package:color_blast/Service/service_favoris.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/comment.dart';
import '../Model/data_manager.dart';
import '../Model/professionnel.dart';
import '../Service/service_comment.dart';

class ServiceDetailsPage extends StatefulWidget {
  final String companyName;
  final String imageUrl;
  final Professionnel professionnel;

  ServiceDetailsPage({required this.companyName, required this.imageUrl, required this.professionnel});

  @override
  _ServiceDetailsPageState createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  bool isStarred = false;
  List<Comment?>? comments = [];
  bool isLoadingComments = true;


  @override
  void initState() {
    super.initState();
    getDatas();
    checkIfProfessionalIsStarred();

  }

  getDatas() async {
    setState(() {
      isLoadingComments = true;
    });

    List<Comment?>? loadedComments = await ServiceComment().getCommentsByIdPro(widget.professionnel.id);

    setState(() {
      comments = loadedComments;
      isLoadingComments = false;
    });
  }

  addFavoris() async {
    int response = await ServiceFavoris().createFavoris(DataManager().client?.id, widget.professionnel);
    if(response == 200){
      //faire un truc
    }
  }

  removeFavoris() async {
    int response = await ServiceFavoris().removeFavoris(DataManager().client?.id, widget.professionnel);
    if(response == 200){
      //faire un truc
    }
  }



  void checkIfProfessionalIsStarred() {
    List<Professionnel?>? favoris = DataManager().favoris;
    if (favoris != null) {
      for (Professionnel? pro in favoris) {
        if (pro?.id == widget.professionnel.id) {
          setState(() {
            isStarred = true;
          });
          break;
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text(widget.companyName),
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
      body: ElementAnimation(1,
        Column(
        children:<Widget> [
          Stack(
            children: <Widget>[
              Container(
                color: Colors.grey,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 16.0,
                right: 16.0,
                child: GestureDetector(
                  onTap: () {
                    if(isStarred == false){
                      setState(() {
                        addFavoris();
                        isStarred = true;
                      });
                    }else{
                      setState(() {
                        removeFavoris();
                        isStarred = false;
                      });
                    }
                  },
                  child: Icon(
                    isStarred ? Icons.star : Icons.star_border,
                    color: isStarred ? Colors.orangeAccent : Colors.white,
                  ),
                ),
              ),
              /*Positioned(
                bottom: 5.0,
                left: 16.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    Text(
                      widget.professionnel.note.toString()+"/5",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),*/
              Positioned(
                bottom: 5.0,
                right: 16.0,
                child: Container(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TakeMeetPage(professionnel: widget.professionnel,)),
                      );
                    },

                    child: Text('Prendre RDV'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: RichText(
              text: TextSpan(
                text: 'Description: ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Colors.black
                ),
                children: [
                  TextSpan(
                    text: widget.professionnel.description,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: 'Lieu: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: widget.professionnel.department + ", " + widget.professionnel.country,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        text: 'Prix moy/H: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: widget.professionnel.price.toString() + "€",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: 'Contact: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: widget.professionnel.mail + " / " + widget.professionnel.phone,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: 'Commentaires: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            child: isLoadingComments
              ? Center(child: CircularProgressIndicator())
              : comments == null || comments!.isEmpty
            ? Center(child: Text("Aucun commentaire pour ce service."))
            : ListView.builder(
              shrinkWrap: true,
              itemCount: comments!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text("${comments?[index]?.lastname[0]}${comments?[index]?.firstname[0]}"),
                  ),
                  title: Text("${comments?[index]?.lastname ?? ""} ${comments?[index]?.firstname ?? ""}"),
                  subtitle: Text(comments?[index]?.content ?? ""),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      SizedBox(width: 5),
                      Text("${comments?[index]?.note ?? 0}/5"),
                    ],
                  ),
                );

              },
            ),
          ),


        ],
      ),
      ),
    );
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Animation/animation.dart';

class SignupPage2 extends StatefulWidget {
  const SignupPage2({Key? key}) : super(key: key);

  @override
  State<SignupPage2> createState() => _SignupPage2State();
}



class _SignupPage2State extends State<SignupPage2> {

  Future<void> _getCurrentLocation() async {
    // Demander la permission de localisation
    PermissionStatus status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      // La permission a été refusée, vous devez demander à l'utilisateur de l'autoriser manuellement dans les paramètres de l'application
      return;
    }

    // La permission a été accordée, vous pouvez maintenant récupérer la localisation de l'appareil
    try {
      // Récupérer la position actuelle
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Récupérer les informations de localisation (pays/ville/région) à partir de la position
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      // Récupérer les informations de localisation de la première marque de place
      Placemark place = placemarks[0];

      String numeroRue = place.subThoroughfare ?? '';
      String nomRue = place.thoroughfare ?? '';

      // Afficher les informations de localisation
      pays = place.country;
      departement = place.administrativeArea;
      codePostal = place.postalCode;
      ville = place.locality;
      adresse = '$nomRue $numeroRue ';


    } catch (e) {
      print(e);
    }
  }

  String? pays;
  String? departement;
  String? codePostal;
  String? ville;
  String? adresse;

  final TextEditingController textPaysController = TextEditingController();
  final TextEditingController textDepartementController = TextEditingController();
  final TextEditingController textCodePostalController = TextEditingController();
  final TextEditingController textVilleController = TextEditingController();
  final TextEditingController textAdresseController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.deepOrange,
                  Colors.orange,
                  Colors.orangeAccent,
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ElementAnimation(1, Text("Inscription", style: TextStyle(color: Colors.white, fontSize: 40),)),
                  SizedBox(height: 10,),
                  ElementAnimation(1.3, Text("Etape 2/2", style: TextStyle(color: Colors.white, fontSize: 18),)),
                  SizedBox(height: 20,),
                  ElementAnimation(1.3,GestureDetector(
                    onTap: () async{
                      await _getCurrentLocation();
                      setState(() {
                      textPaysController.text = pays ?? '';
                      textDepartementController.text = departement ?? '';
                      textCodePostalController.text = codePostal ?? '';
                      textVilleController.text = ville ?? '';
                      textAdresseController.text = adresse ?? '';
                      });
                    },
                    child: Text("Géolocalise moi",style: TextStyle(color: Colors.white, fontSize: 15)),
                  )),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60,),
                        ElementAnimation(1.4, Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(225, 95, 27, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )]
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey))
                                ),
                                child: TextField(
                                  controller: textPaysController,
                                  decoration: InputDecoration(
                                      hintText: "Pays",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey))
                                ),
                                child: TextField(
                                  controller: textDepartementController,
                                  decoration: InputDecoration(
                                      hintText: "Département",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey))
                                ),
                                child: TextField(
                                  controller: textCodePostalController,
                                  decoration: InputDecoration(
                                      hintText: "Code postal",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey))
                                ),
                                child: TextField(
                                  controller: textVilleController,
                                  decoration: InputDecoration(
                                      hintText: "Ville",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  //border: Border(bottom: BorderSide(color: Colors.grey))
                                ),
                                child: TextField(
                                  controller: textAdresseController,
                                  decoration: InputDecoration(
                                      hintText: "Adresse",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                        SizedBox(height: 40,),
                        ElementAnimation(1.6, Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.orange[900]
                          ),
                          child: Center(
                            child: Text("Valider", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        )),
                        SizedBox(height: 50,),
                        //FadeAnimation(1.7, Text("Continue with social media", style: TextStyle(color: Colors.grey),)),
                        SizedBox(height: 30,),

                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

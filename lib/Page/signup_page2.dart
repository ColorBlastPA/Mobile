
import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/professionnel.dart';
import 'package:color_blast/Page/signup_page3.dart';
import 'package:color_blast/Service/service_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Model/client.dart';

import '../Animation/animation.dart';
import 'login_page.dart';

class SignupPage2 extends StatefulWidget {
  const SignupPage2(this.firstname, this.lastname, this.mail, this.password);
  final String firstname;
  final String lastname;
  final String mail;
  final String password;

  @override
  State<SignupPage2> createState() => _SignupPage2State(this.firstname,this.lastname,this.mail,this.password);
}



class _SignupPage2State extends State<SignupPage2> {

  String firstname = "";
  String lastname = "";
  String mail = "";
  String password = "";


  _SignupPage2State(String firstname, String lastname, String mail, String password){
    this.firstname = firstname;
    this.lastname = lastname;
    this.password = password;
    this.mail = mail;
  }


  Future<void> createAccount() async {
    Client client = Client(lastname: this.lastname, firstname: this.firstname, mail: this.mail, password: this.password, country: this.pays ?? "", department: this.departement ?? "", postalCode: this.codePostal ?? "", city: this.ville ?? "", address: this.adresse ?? "", id: 1, avatar: '');

    var response = await ServiceClient().createClient(client);
    if(response == 200){
      Navigator.push(context,
          MaterialPageRoute<void>(
              builder:(BuildContext context) {
                return LoginPage(WorkspaceClient: true);
              }));
    }else{
      print("erreur");
    }
  }

  Future<void> goToSign3() async {
    Professionnel pro = Professionnel(id: 1, lastname: this.lastname, firstname: this.firstname, mail: this.mail, password: this.password, country: this.pays ?? "", department: this.departement ?? "", postalCode: this.codePostal ?? "", city: this.ville ?? "", companyName: "", price: 0, phone: "", note: 0, description: "", idCertificate: null, avatar: '', waiting: true);

    Navigator.push(context,
        MaterialPageRoute<void>(
            builder:(BuildContext context) {
              return SignupPage3(pro);
            }));
  }


  Future<void> _getCurrentLocation() async {
    // Demander la permission de localisation
    PermissionStatus status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      String numeroRue = place.subThoroughfare ?? '';
      String nomRue = place.thoroughfare ?? '';

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
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.deepOrange,
                  Colors.orange,
                  Colors.orangeAccent,
                ],
              ),
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
                      ElementAnimation(1, Text(
                        "Inscription",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )),
                      SizedBox(height: 10,),
                      ElementAnimation(1.3, Text(
                        "Etape 2/2",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                      SizedBox(height: 20,),
                      ElementAnimation(1.3, GestureDetector(
                        onTap: () async {
                          await _getCurrentLocation();
                          setState(() {
                            textPaysController.text = pays ?? '';
                            textDepartementController.text = departement ?? '';
                            textCodePostalController.text = codePostal ?? '';
                            textVilleController.text = ville ?? '';
                            textAdresseController.text = adresse ?? '';
                          });
                        },
                        child: Text(
                          "Géolocalise moi",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
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
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  )
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey)),
                                    ),
                                    child: TextField(
                                      controller: textPaysController,
                                      decoration: InputDecoration(
                                        hintText: "Pays",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey)),
                                    ),
                                    child: TextField(
                                      controller: textDepartementController,
                                      decoration: InputDecoration(
                                        hintText: "Département",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey)),
                                    ),
                                    child: TextField(
                                      controller: textCodePostalController,
                                      decoration: InputDecoration(
                                        hintText: "Code postal",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey)),
                                    ),
                                    child: TextField(
                                      controller: textVilleController,
                                      decoration: InputDecoration(
                                        hintText: "Ville",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: DataManager().workspaceClient!,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        //border: Border(bottom: BorderSide(color: Colors.grey))
                                      ),
                                      child: TextField(
                                        controller: textAdresseController,
                                        decoration: InputDecoration(
                                          hintText: "Adresse",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            SizedBox(height: 40,),
                            DataManager().workspaceClient == true ?
                            ElementAnimation(1.6, GestureDetector(
                              onTap: () {
                                createAccount();
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.orange[900],
                                ),
                                child: Center(
                                  child: Text(
                                    "Valider",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )) :
                          ElementAnimation(1.6, GestureDetector(
                          onTap: () {
                          goToSign3();
                          },
                          child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.orange[900],
                          ),
                          child: Center(
                            child: Text(
                              "Continuer",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),

                            SizedBox(height: 50,),
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
          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

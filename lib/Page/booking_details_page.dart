import 'dart:io';
import 'dart:typed_data';
import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/line.dart';
import 'package:color_blast/Model/messagerie.dart';
import 'package:color_blast/Page/profile_page.dart';
import 'package:color_blast/Service/service_booking.dart';
import 'package:color_blast/Service/service_email.dart';
import 'package:color_blast/Service/service_line.dart';
import 'package:color_blast/Service/service_messagerie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Model/booking.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class BookingDetailsPage extends StatefulWidget {
  final Booking? booking;
  final bool context;

  BookingDetailsPage({required this.booking, required this.context});

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  File? selectedFile;
  String selectedFileName = '';


  Future<void> refuseBooking() async {
    var response = await ServiceBooking().deleteBooking(widget.booking?.booking.id);
    if(response == 200){
      Navigator.of(context).pop(true);
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erreur"),
            content: Text("Une erreur est survenue."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> validateBooking() async{
    if(DataManager().workspaceClient == true){
      widget.booking?.booking.waiting = false;
      var response = await ServiceBooking().updateBooking(widget.booking!.booking.id, widget.booking!.booking);
      if(response == 200){
        MessagerieClass? messagerieClass = await ServiceMessagerie().getMessageriesByIdClientAndPro(widget.booking?.booking.idClient, widget.booking?.booking.idPro);

        await ServiceLine().appendLine(Line(id: 1, idMessagerie: messagerieClass!.id, mail: "", lastname: "Color", firstname: "Blast", content: "Le client accepte le service.", date: DateTime.now()));

        Navigator.of(context).pop(true);
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Erreur"),
              content: Text("Une erreur est survenue de la validation du booking."),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }else{
      if (selectedFile != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://api-colorblast.current.ovh/api/upload-quote/${widget.booking?.booking.id}'),
        );
        Uint8List fileBytes = await selectedFile!.readAsBytes();

        var stream = Stream.fromIterable([fileBytes]);

        request.files.add(
          http.MultipartFile(
            'file',
            stream,
            fileBytes.length,
            filename: selectedFile!.path.split('/').last,
            contentType: MediaType('application', 'pdf'),
          ),
        );

        var response = await request.send();

        if (response.statusCode == 200) {
          print(widget.booking?.booking.idClient);
          print(widget.booking?.booking.idPro);
          MessagerieClass? messagerieClass = await ServiceMessagerie().getMessageriesByIdClientAndPro(widget.booking?.booking.idClient, widget.booking?.booking.idPro);

          await ServiceLine().appendLine(Line(id: 1, idMessagerie: messagerieClass!.id, mail: "", lastname: "Color", firstname: "Blast", content: "Cette demande possède un devis.", date: DateTime.now()));

          Navigator.of(context).pop(true);
          print("Fichier PDF téléchargé avec succès : ${selectedFile!.path}");

        } else {
          // Gérer les erreurs de téléchargement du fichier
          print("Erreur lors du téléchargement du fichier PDF : ${response.statusCode}");
          print(await response.stream.bytesToString());
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Erreur"),
                content: Text("Une erreur est survenue lors du téléchargement du fichier PDF."),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Erreur"),
              content: Text("Si vous validez la demande, veuillez mettre un devis en format pdf."),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

  }

  Future<void> terminateBooking() async{
    await ServiceEmail().getCommentProEmail(widget.booking?.booking.idClient ?? 0, widget.booking?.booking.idPro ?? 0);
    var response = await ServiceBooking().deleteBooking(widget.booking?.booking.id);
    if(response == 200){
      Navigator.of(context).pop(true);
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erreur"),
            content: Text("Une erreur est survenue."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails de la demande"),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informations de nom, prénom, ville et adresse avec des icônes
            Row(
              children: [
                Icon(Icons.person, size: 24.0),
                SizedBox(width: 8.0),
                Text('Nom: ${widget.booking?.booking.lastname}'),
              ],
            ),
            SizedBox(height: 8.0),

            Row(
              children: [
                Icon(Icons.person, size: 24.0),
                SizedBox(width: 8.0),
                Text('Prénom: ${widget.booking?.booking.firstname}'),
              ],
            ),
            SizedBox(height: 8.0),

            Row(
              children: [
                Icon(Icons.location_city, size: 24.0),
                SizedBox(width: 8.0),
                Text('Ville: ${widget.booking?.booking.city}'),
              ],
            ),
            SizedBox(height: 8.0),

            Row(
              children: [
                Icon(Icons.location_on, size: 24.0),
                SizedBox(width: 8.0),
                Text('Adresse: ${widget.booking?.booking.address}'),
              ],
            ),
            SizedBox(height: 8.0),

            // Informations de surface, dhDébut et dhFin avec des icônes
            Row(
              children: [
                Icon(Icons.square_foot, size: 24.0),
                SizedBox(width: 8.0),
                Text('Surface: ${widget.booking?.booking.surface} m²'),
              ],
            ),
            SizedBox(height: 8.0),

            Row(
              children: [
                Icon(Icons.date_range, size: 24.0),
                SizedBox(width: 8.0),
                Text('Date de début: ${widget.booking?.booking.dhDebut.toString()}'),
              ],
            ),
            SizedBox(height: 8.0),

            Row(
              children: [
                Icon(Icons.date_range, size: 24.0),
                SizedBox(width: 8.0),
                Text('Date de fin: ${widget.booking?.booking.dhFin.toString()}'),
              ],
            ),
            SizedBox(height: 16.0), // Espacement

            // Liste des produits sous forme de cartes
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.booking?.product.length,
              itemBuilder: (context, index) {
                final product = widget.booking?.product[index];
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(product?.image ?? ''),
                        ),
                      ),
                    ),
                    title: Text(product?.name ?? ''),
                    subtitle: Text('Prix: ${product?.price}'),
                  ),
                );
              },
            ),

            SizedBox(height: 16.0), // Espacement

            // Bouton "Chercher un PDF" centré horizontalement
            Center(
              child: (() {
                if (DataManager().workspaceClient == false && widget.booking?.quote == null) {
                  return ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );

                      if (result != null) {
                        selectedFile = File(result.files.single.path!);
                        setState(() {
                          selectedFileName = selectedFile!.path.split('/').last;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.file_upload,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Sélectionner un fichier PDF",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if ((DataManager().workspaceClient == true && widget.booking?.quote == null)) {
                  // Ne pas afficher le bouton
                  return SizedBox.shrink();
                } else if ((DataManager().workspaceClient == true && widget.booking?.quote != null) || (DataManager().workspaceClient == false && widget.booking?.quote != null)) {
                  // Afficher les informations de devis
                  return InkWell(
                    onTap: () {
                      launch(widget.booking?.quote?.url ?? "");
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.picture_as_pdf,
                          size: 48.0,
                          color: Colors.blue,
                        ),
                        SizedBox(height: 4.0),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.booking?.quote?.filename ?? "",
                            style: TextStyle(
                              color: Colors.blue, // Couleur du texte
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Par défaut, retournez une boîte vide
                  return SizedBox.shrink();
                }
              })(),
            ),
            SizedBox(height: 10),
            Text(selectedFileName),
            SizedBox(height: 16.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: (() {
                if (DataManager().workspaceClient == true && widget.context == true) {
                  // Ne pas afficher de bouton si DataManager().workspaceClient == true && widget.context == true
                  return <Widget>[];
                } else if (DataManager().workspaceClient == true && widget.context == false && widget.booking?.quote == null) {
                  // Afficher le bouton "Annuler" si DataManager().workspaceClient == true && widget.context == false && widget.booking?.quote == null
                  return <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        refuseBooking();
                      },
                      child: Text('Annuler'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                  ];
                } else if (DataManager().workspaceClient == true && widget.context == false && widget.booking?.quote != null) {
                  // Afficher les boutons "Refuser" et "Accepter" si DataManager().workspaceClient == true && widget.context == false && widget.booking?.quote != null
                  return <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        refuseBooking();
                      },
                      child: Text('Refuser'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        validateBooking();
                      },
                      child: Text('Accepter'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                    ),
                  ];
                } else if (DataManager().workspaceClient == false && widget.context == true) {
                  // Afficher le bouton "Terminer" si DataManager().workspaceClient == false && widget.context == true
                  return <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        terminateBooking();
                      },
                      child: Text('Terminer'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                    ),
                  ];
                } else if (DataManager().workspaceClient == false && widget.context == false && widget.booking?.quote == null) {
                  // Afficher les boutons "Refuser" et "Accepter" si DataManager().workspaceClient == false && widget.context == false && widget.booking?.quote == null
                  return <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        refuseBooking();
                      },
                      child: Text('Refuser'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        validateBooking();
                      },
                      child: Text('Accepter'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                    ),
                  ];
                } else if (DataManager().workspaceClient == false && widget.context == false && widget.booking?.quote != null) {
                  // Afficher le bouton "Annuler" si DataManager().workspaceClient == false && widget.context == false && widget.booking?.quote != null
                  return <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        refuseBooking();
                      },
                      child: Text('Annuler'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                  ];
                } else {
                  // Par défaut, retournez une boîte vide
                  return <Widget>[];
                }
              })(),
            ),



          ],
        ),
      ),
    );
  }


}

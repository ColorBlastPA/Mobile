import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../Model/booking.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class BookingDetailsPage extends StatefulWidget {
  final Booking? booking;

  BookingDetailsPage({required this.booking});

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  File? selectedFile;
  String selectedFileName = '';

  Future<void> validateBooking() async{
      if (selectedFile != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://api-colorblast.current.ovh/api/upload-quote/${widget.booking?.booking.id}'),
        );

        // Lisez le contenu du fichier en tant que liste d'octets (Uint8List)
        Uint8List fileBytes = await selectedFile!.readAsBytes();

        // Créez un flux à partir de la liste d'octets (Uint8List)
        var stream = Stream.fromIterable([fileBytes]);

        request.files.add(
          http.MultipartFile(
            'file',
            stream,
            fileBytes.length,
            filename: selectedFile!.path.split('/').last, // Nom de fichier
            contentType: MediaType('application', 'pdf'), // Type de contenu
          ),
        );

        var response = await request.send();

        if (response.statusCode == 200) {
          // Le fichier a été téléchargé avec succès
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
    print("Erreur lors de la création du professionnel");
    // Gérer l'erreur lors de la création du professionnel
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
              child: ElevatedButton(
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
              ),
            ),
            SizedBox(height: 10),
            Text(selectedFileName),
            SizedBox(height: 16.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Ajoutez ici la logique pour refuser le booking
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

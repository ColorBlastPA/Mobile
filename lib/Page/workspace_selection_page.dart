import 'package:color_blast/Animation/animation.dart';
import 'package:color_blast/Controller/notification_service.dart';
import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/io.dart';
import 'package:timezone/data/latest.dart' as tz;

class WorkspaceSelectionPage extends StatefulWidget {
  const WorkspaceSelectionPage({Key? key}) : super(key: key);

  @override
  State<WorkspaceSelectionPage> createState() => _WorkspaceSelectionPageState();
}

class _WorkspaceSelectionPageState extends State<WorkspaceSelectionPage> {






  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    requestNotificationAndStoragePermissions();



  }

  Future<void> requestNotificationAndStoragePermissions() async {
    PermissionStatus notificationStatus = await Permission.notification.request();
    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus galleryStatus = await Permission.photos.request();
    PermissionStatus filesStatus = await Permission.storage.request();

    if (notificationStatus.isGranted) {

    } else {

    }

    if (cameraStatus.isGranted) {

    } else {

    }

    if (galleryStatus.isGranted) {

    } else {

    }

    if (filesStatus.isGranted) {

    } else {

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sélectionner un espace: "),
        automaticallyImplyLeading: false,
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
      body: ElementAnimation(1,Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {

                DataManager().workspaceClient = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage(WorkspaceClient: true)),
                );

              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Coin arrondis
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange,
                      Colors.orange,
                      Colors.orangeAccent,], // Dégradé de couleur
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Espace Client',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 100),
            GestureDetector(
              onTap: () {
                DataManager().workspaceClient = false;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage(WorkspaceClient: false)),
                );
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Colors.orangeAccent,
                      Colors.orange,
                      Colors.deepOrange,], // Dégradé de couleur
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Espace Professionnel',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            //Text('Message reçu du serveur: $receivedMessage'),
          ],
        ),
      ),)
    );
  }
}




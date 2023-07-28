import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Page/service_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/professionnel.dart';
import '../Service/service_pro.dart';

class FavorisListPage extends StatefulWidget {
  const FavorisListPage({Key? key}) : super(key: key);

  @override
  State<FavorisListPage> createState() => _FavorisListPageState();
}

class _FavorisListPageState extends State<FavorisListPage> {
  List<Professionnel?>? favoris = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    favoris = await ServicePro().getProFavorisById(DataManager().client?.id);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> refreshData() async {
    setState(() {
      getData();
    });
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: isLoading
          ? Center(
        child: CircularProgressIndicator(), // Affiche un spinner circulaire
      )
          : favoris?.isEmpty ?? true // Vérifie si le tableau est vide ou null
          ? Center(
        child: Text("Vous n'avez pas de favoris"),
      ) // Affiche le message si le tableau est vide
          : ListView.builder(
        itemCount: favoris?.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetailsPage(
                    companyName: favoris![index]!.companyName,
                    imageUrl:
                    "https://www.batiperform.com/fichiers_site/a6178bat/contenu_pages/entreprise-generale-batiment-1.jpg",
                    professionnel: favoris![index]!,
                  ),
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                    favoris![index]!.lastname[0] +
                        favoris![index]!.firstname[0]),
              ),
              title: Text(
                  '${favoris![index]!.lastname} ${favoris![index]!.firstname}'),
              subtitle: Text(
                  '${favoris![index]!.country}, ${favoris![index]!.city}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Insérez ici le code pour afficher l'étoile et la note sur 5 si nécessaire.
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


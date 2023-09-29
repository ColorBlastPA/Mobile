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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
//favoris = DataManager().favoris;
  }

  Future<void> getData() async {
    favoris = await ServicePro().getProFavorisById(DataManager().client?.id);
    setState(() {
      isLoading = false;
    });
  }

  void _navigateToServiceDetails(Professionnel professionnel) async {
    // Naviguer vers la page des détails du service.
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailsPage(
          companyName: professionnel.companyName,
          imageUrl: professionnel.image ?? "https://www.batiperform.com/fichiers_site/a6178bat/contenu_pages/entreprise-generale-batiment-1.jpg",
          professionnel: professionnel,
          refreshCallback: refreshData,
        ),
      ),
    );

    // Après avoir navigué de la page des détails du service, rafraîchissez les données si nécessaire.
    getData();
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
                child: CircularProgressIndicator(),
            )
          : favoris?.isEmpty ?? true
          ? Center(
            child: Text("Vous n'avez pas de favoris"),
          )
          : ListView.builder(
            itemCount: favoris?.length,
            itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _navigateToServiceDetails(favoris![index]!);
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetailsPage(
                    companyName: favoris![index]!.companyName,
                    imageUrl:
                        favoris![index]!.image ??
                    "https://www.batiperform.com/fichiers_site/a6178bat/contenu_pages/entreprise-generale-batiment-1.jpg",
                    professionnel: favoris![index]!,
                  ),
                ),
              );*/
            },
            child: ListTile(
              leading: favoris![index]!.avatar != null && favoris![index]!.avatar != ""
                  ? CircleAvatar(
                    backgroundImage: NetworkImage(favoris![index]!.avatar!),
              )
                  : CircleAvatar(
                    child: Text(favoris![index]!.lastname[0] + favoris![index]!.firstname[0]),
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


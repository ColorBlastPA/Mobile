import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Page/service_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/professionnel.dart';

class FavorisListPage extends StatefulWidget {
  const FavorisListPage({Key? key}) : super(key: key);

  @override
  State<FavorisListPage> createState() => _FavorisListPageState();
}

class _FavorisListPageState extends State<FavorisListPage> {
  List<Professionnel?>? pro = DataManager().professionnel;

  Future<void> refreshData() async {
    setState(() {
      pro = DataManager().professionnel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: ListView.builder(
        itemCount: pro?.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetailsPage(
                    companyName: pro![index]!.companyName,
                    imageUrl: "https://www.expert-chantier.fr/assets/components/phpthumbof/cache/entreprise.f0e06343dbddff9666ef083d1ba8f9d4.jpg",
                    professionnel: pro![index]!,
                  ),
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                child: Text(pro![index]!.lastname[0] + pro![index]!.firstname[0]),
              ),
              title: Text('${pro![index]!.lastname} ${pro![index]!.firstname}'),
              subtitle: Text('${pro![index]!.country}, ${pro![index]!.city}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      Text('${pro![index]!.note}/5'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


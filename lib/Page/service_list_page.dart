import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Page/service_details_page.dart';
import 'package:color_blast/Service/service_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/professionnel.dart';
import '../Model/user.dart';


class ServiceListPage extends StatefulWidget {
  const ServiceListPage({Key? key}) : super(key: key);

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  List<Professionnel?>? filteredData = [];
  List<Professionnel?>? pro = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    pro = await ServicePro().getAllPro();
    setState(() {
      filteredData = pro;
      isLoading = false;
    });
  }

  void filterList(String query) {
    setState(() {
      filteredData = pro!
          .where((person) =>
      person!.lastname.toLowerCase().contains(query.toLowerCase()) ||
          person.firstname.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }



  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    await getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => filterList(value),
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : ListView.builder(
                      itemCount: filteredData?.length,
                      itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceDetailsPage(
                            companyName: filteredData![index]!.companyName,
                            imageUrl:
                            "https://www.expert-chantier.fr/assets/components/phpthumbof/cache/entreprise.f0e06343dbddff9666ef083d1ba8f9d4.jpg",
                            professionnel: filteredData![index]!,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(filteredData![index]!.lastname[0] +
                            filteredData![index]!.firstname[0]),
                      ),
                      title: Text(
                          '${filteredData![index]!.lastname} ${filteredData![index]!.firstname}'),
                      subtitle: Text(
                          '${filteredData![index]!.country}, ${filteredData![index]!.city}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              Text('${filteredData![index]!.note}/5'),
                            ],
                          ),
                        ],
                      ),
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








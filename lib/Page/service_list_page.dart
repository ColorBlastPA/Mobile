import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/user.dart';


class ServiceListPage extends StatefulWidget {
  const ServiceListPage({Key? key}) : super(key: key);

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  List<User> data = [
    User(nom: 'Dupont', prenom: 'Jean', pays: 'France', ville: 'Paris', note: 3),
    User(nom: 'Martin', prenom: 'Sophie', pays: 'Belgique', ville: 'Bruxelles', note: 4),
    User(nom: 'Müller', prenom: 'Hans', pays: 'Allemagne', ville: 'Berlin', note: 2),
    User(nom: 'Rossi', prenom: 'Luigi', pays: 'Italie', ville: 'Rome', note: 5),
    User(nom: 'García', prenom: 'Pablo', pays: 'Espagne', ville: 'Madrid', note: 3),
    User(nom: 'Silva', prenom: 'Maria', pays: 'Portugal', ville: 'Lisbonne', note: 4),
    User(nom: 'Andersen', prenom: 'Jens', pays: 'Danemark', ville: 'Copenhague', note: 2),
    User(nom: 'Wilson', prenom: 'John', pays: 'Royaume-Uni', ville: 'Londres', note: 5),
    User(nom: 'Smith', prenom: 'Emily', pays: 'Canada', ville: 'Montréal', note: 3),
    User(nom: 'Lee', prenom: 'Jung-Su', pays: 'Corée du Sud', ville: 'Séoul', note: 4),
    User(nom: 'Tanaka', prenom: 'Yuki', pays: 'Japon', ville: 'Tokyo', note: 2),
    User(nom: 'Santos', prenom: 'Miguel', pays: 'Brésil', ville: 'Rio de Janeiro', note: 5),
    User(nom: 'Chen', prenom: 'Yan', pays: 'Chine', ville: 'Pékin', note: 3),
    User(nom: 'López', prenom: 'Carlos', pays: 'Mexique', ville: 'Mexico', note: 4),
    User(nom: 'Kowalski', prenom: 'Jan', pays: 'Pologne', ville: 'Varsovie', note: 2),
    User(nom: 'Ivanov', prenom: 'Dmitri', pays: 'Russie', ville: 'Moscou', note: 5),
    User(nom: 'Álvarez', prenom: 'Juan', pays: 'Colombie', ville: 'Bogota', note: 3),
    User(nom: 'Nguyen', prenom: 'Hoa', pays: 'Vietnam', ville: 'Hanoi', note: 4),
    User(nom: 'González', prenom: 'Alejandro', pays: 'Argentine', ville: 'Buenos Aires', note: 2),

  ];

  List<User> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = data;
  }

  void filterList(String query) {
    setState(() {
      filteredData = data
          .where((person) => person.nom.toLowerCase().contains(query.toLowerCase()) || person.prenom.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                      child: Text(filteredData[index].nom[0]+ filteredData[index].prenom[0])
                  ),
                  title: Text('${filteredData[index].nom} ${filteredData[index].prenom}'),
                  subtitle: Text('${filteredData[index].pays}, ${filteredData[index].ville}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Text('${filteredData[index].note}/5'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}






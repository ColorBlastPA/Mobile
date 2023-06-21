import 'package:color_blast/Page/product_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  ShopPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> items = [
    {
      'name': 'Objet 1',
      'price': 10,
      'category': 'Catégorie 1',
      'rating': 4,
      'image': 'https://picsum.photos/id/237/200/200',
    },
    {
      'name': 'Objet 2',
      'price': 20,
      'category': 'Catégorie 1',
      'rating': 3,
      'image': 'https://picsum.photos/id/238/200/200',
    },
    {
      'name': 'Objet 3',
      'price': 30,
      'category': 'Catégorie 2',
      'rating': 5,
      'image': 'https://picsum.photos/id/239/200/200',
    },
    {
      'name': 'Objet 4',
      'price': 40,
      'category': 'Catégorie 2',
      'rating': 2,
      'image': 'https://picsum.photos/id/240/200/200',
    },
    {
      'name': 'Objet 5',
      'price': 50,
      'category': 'Catégorie 3',
      'rating': 4,
      'image': 'https://picsum.photos/id/241/200/200',
    },
    {
      'name': 'Objet 6',
      'price': 60,
      'category': 'Catégorie 3',
      'rating': 3,
      'image': 'https://picsum.photos/id/242/200/200',
    },
    {
      'name': 'Objet 7',
      'price': 70,
      'category': 'Catégorie 4',
      'rating': 5,
      'image': 'https://picsum.photos/id/243/200/200',
    },
    {
      'name': 'Objet 8',
      'price': 80,
      'category': 'Catégorie 4',
      'rating': 2,
      'image': 'https://picsum.photos/id/244/200/200',
    },
    {
      'name': 'Objet 9',
      'price': 90,
      'category': 'Catégorie 5',
      'rating': 4,
      'image': 'https://picsum.photos/id/244/200/200',
    },
    {
      'name': 'Objet 10',
      'price': 100,
      'category': 'Catégorie 5',
      'rating': 3,
      'image': 'https://picsum.photos/id/244/200/200',
    },
  ];

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  TextEditingController searchController = TextEditingController(); // ajouter un contrôleur pour la barre de recherche

  List<Map<String, dynamic>> filteredItems = [];
  @override
  void dispose() {
    searchController.dispose(); // nettoyer le contrôleur lorsque la page est fermée
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void filterList(String query) {
    List<Map<String, dynamic>> filteredList = [];
    widget.items.forEach((item) {
      if (item['name'].toLowerCase().contains(query.toLowerCase())) {
        filteredList.add(item);
      }
    });
    setState(() {
      filteredItems = filteredList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Magasin"),
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Action à effectuer lors du clic sur l'icône du panier
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
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
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => SizedBox(height: 20),
              itemCount: (filteredItems.length / 2).ceil(),
              itemBuilder: (BuildContext context, int index) {
                int leftIndex = index * 2;
                int rightIndex = leftIndex + 1;

                if (rightIndex >= filteredItems.length) {
                  rightIndex = leftIndex;
                  filteredItems.add({});
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildListItem(filteredItems[leftIndex], () => onItemClicked(filteredItems[leftIndex])),
                    buildListItem(filteredItems[rightIndex], () => onItemClicked(filteredItems[rightIndex])),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListItem(Map<String, dynamic> item, void Function() onClick) { // ajouter le callback
    if (item.isEmpty) {
      return SizedBox(); // élément vide pour remplacer le dernier élément seul
    }
    return GestureDetector( // ajouter un GestureDetector pour écouter les clics
      onTap: onClick,
      child: Expanded(
        child: Column(
          children: [
            CircleAvatar(
              radius: 60, // ajuster la taille du cercle ici
              backgroundImage: NetworkImage(item['image']),
            ),
            SizedBox(height: 10),
            Text(item['name'], style: TextStyle(fontSize: 20)),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.yellow),
                SizedBox(width: 5),
                Text('${item['rating']}/5'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onItemClicked(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailsPage()),
    );
    // ici, vous pouvez ajouter du code pour gérer l'action de clic
  }

}

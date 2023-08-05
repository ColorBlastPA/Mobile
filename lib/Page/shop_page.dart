import 'package:color_blast/Page/basket_product_page.dart';
import 'package:color_blast/Page/product_details_page.dart';
import 'package:color_blast/Service/service_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/product.dart';

class ShopPage extends StatefulWidget {
  ShopPage({Key? key}) : super(key: key);


  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Product?>? products = [];
  TextEditingController searchController = TextEditingController();
  List<Product?>? filteredItems = [];
  List<Product?>? allProducts = [];

  @override
  void initState() {
    super.initState();
    getDatas().then((loadedProducts) {
      setState(() {
        products = loadedProducts;
        allProducts = loadedProducts;
        filteredItems = loadedProducts;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<List<Product?>?> getDatas() async {
    List<Product?>? products = await ServiceProduct().getAllProducts();
    return products;
  }

  void filterList(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = allProducts;
      });
    } else {
      List<Product?> filteredList = allProducts!
          .where((item) =>
          item!.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        filteredItems = filteredList;
      });
    }
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BasketProductPage()),
              );
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
            child: filteredItems == null || filteredItems!.isEmpty
                ? Center(
              child: filteredItems == null
                  ? CircularProgressIndicator()
                  : Text("Aucun produit ne correspond"),
            )
                : ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 20),
              itemCount: filteredItems!.length,
              itemBuilder: (BuildContext context, int index) {
                return buildListItem(
                    filteredItems![index]!,
                        () => onItemClicked(filteredItems![index]!));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListItem(Product item, void Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage("https://picsum.photos/id/242/200/200"),
          ),
          SizedBox(height: 10),
          Text(item.name, style: TextStyle(fontSize: 20)),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Icon(Icons.star, color: Colors.yellow),
              //SizedBox(width: 5),
              Text('${item.price} €'),
            ],
          ),
        ],
      ),
    );
  }

  void onItemClicked(Product item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailsPage(item)),
    );
  }
}

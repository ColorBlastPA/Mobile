import 'package:flutter/material.dart';
import '../Service/service_product.dart';
import '../Model/product.dart';
import '../Page/product_details_page.dart';
import '../Page/basket_product_page.dart';

class ShopPage extends StatefulWidget {
  ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Product?>? products = [];
  List<Product?>? filteredItems = [];
  List<Product?>? allProducts = [];
  List<bool> selectedCategories = [false, false, false]; // EXTERN, INTERN, ACCESSORY
  List<String> selectedCategoryNames = ['EXTERN', 'INTERN', 'ACCESSORY']; // Names of the categories
  TextEditingController searchController = TextEditingController();

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

  void filterByCategory(List<String> categories) {
    if (categories.isEmpty) {
      setState(() {
        filteredItems = allProducts;
      });
    } else {
      setState(() {
        filteredItems = allProducts!
            .where((item) => categories.contains(item!.category))
            .toList();
      });
    }
  }

  void filterList(String query) {
    if (query.isEmpty) {
      filterByCategory(getSelectedCategories());
    } else {
      List<Product?> filteredList = filteredItems!
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: selectedCategoryNames.map((tagName) {
              int index = selectedCategoryNames.indexOf(tagName);
              return buildTag(tagName, index);
            }).toList(),
          ),
          SizedBox(height: 20),
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

  Widget buildTag(String tagName, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategories[index] = !selectedCategories[index];
          filterByCategory(getSelectedCategories());
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selectedCategories[index] ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          tagName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildListItem(Product item, void Function() onClick) {
    String? imageUrl = (item.image != null && item.image != "")
        ? item.image
        : "https://picsum.photos/id/242/200/200";

    return GestureDetector(
      onTap: onClick,
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(imageUrl!),
          ),
          SizedBox(height: 10),
          Text(item.name, style: TextStyle(fontSize: 20)),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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

  List<String> getSelectedCategories() {
    List<String> selectedCategoryNames = [];
    for (int i = 0; i < selectedCategories.length; i++) {
      if (selectedCategories[i]) {
        if (i == 0) {
          selectedCategoryNames.add("EXTERN");
        } else if (i == 1) {
          selectedCategoryNames.add("INTERN");
        } else if (i == 2) {
          selectedCategoryNames.add("ACCESSORY");
        }
      }
    }
    return selectedCategoryNames;
  }


}

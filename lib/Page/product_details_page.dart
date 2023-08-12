import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Page/basket_product_page.dart';
import 'package:color_blast/Service/service_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';

import '../Animation/animation.dart';
import '../Model/comment.dart';
import '../Model/product.dart';
import '../Service/service_panier.dart';

class ProductDetailsPage extends StatefulWidget {

  const ProductDetailsPage(this.product);

  final Product product;

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState(this.product);
}


class _ProductDetailsPageState extends State<ProductDetailsPage> {
  List<Comment?>? comments = [];
  Product? product;
  List<Item> _items = [];

  _ProductDetailsPageState(Product product) {
    this.product = product;
  }

  bool commentsLoading = true;

  @override
  void initState() {
    super.initState();
    getDatas();
  }

  num count = 0;

  addPanier(int count) async {
    final clientId = DataManager().client?.id;
    final productId = this.product?.id;

    for (int i = 0; i < count; i++) {
      final response = await ServicePanier().createPanier(clientId, productId);
      if (response == 201) {
        print("ajout effectué");
      } else {
        print("erreur");
      }
    }
  }


  getDatas() async {
    List<Comment?>? loadedComments =
    await ServiceComment().getCommentsByIdProduct(this.product!.id);
    setState(() {
      comments = loadedComments;
      commentsLoading = false;
      _items = [
        Item(
          headerValue: 'Description',
          expandedValue:
          'Magnifique pot de peinture rouge de bonne qualité. En vrai achete-le c\'est trop bien',
          isExpanded: false,
        ),
        Item(
          headerValue: 'Avis',
          expandedValue: Container(
            height: 500,
            child: commentsLoading
                ? Center(child: CircularProgressIndicator())
                : comments == null || comments!.isEmpty
                ? Center(child: Text("Aucun avis pour ce produit"))
                : ListView.builder(
              itemCount: comments!.length,
              itemBuilder: (BuildContext context, int index) {
                Comment? comment = comments![index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                        "${comment?.lastname[0]}${comment?.firstname[0]}"),
                  ),
                  title: Text(
                      "${comment?.lastname ?? ""} ${comment?.firstname ?? ""}"),
                  subtitle: Text(comment?.content ?? ""),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      SizedBox(width: 5),
                      Text("${comment?.note ?? 0}/5"),
                    ],
                  ),
                );
              },
            ),
          ),
          isExpanded: false,
        ),
      ];
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Détails du produit'),
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
      body: ElementAnimation(
        1,
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.network(
                  "https://www.outillage-pierre.com/16309-tm_thickbox_default/pot-de-peinture-technicolor-85-ml.jpg",
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: widget.product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            text: 'Prix: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "${widget.product.price} €",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 25,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(left: 55.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: ElegantNumberButton(
                              initialValue: count,
                              buttonSizeWidth: 40,
                              buttonSizeHeight: 40,
                              color: Colors.orangeAccent,
                              minValue: 0,
                              maxValue: 100,
                              step: 1,
                              decimalPlaces: 0,
                              onChanged: (value) {
                                setState(() {
                                  count = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  addPanier(count.toInt());
                },

                child: Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.orange[900],
                  ),
                  child: Center(
                    child: Text(
                      "Ajouter au panier",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              ExpansionPanelList(
                expandedHeaderPadding: EdgeInsets.all(0),
                animationDuration: Duration(milliseconds: 500),
                children: _items.map<ExpansionPanel>((Item item) {
                  return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(item.headerValue),
                      );
                    },
                    body: item.expandedValue is Widget
                        ? item.expandedValue
                        : Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(item.expandedValue),
                    ),
                    isExpanded: item.isExpanded,
                  );
                }).toList(),
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _items[index].isExpanded = !isExpanded;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


}


class Item {
  Item({
    required this.headerValue,
    required this.expandedValue,
    required this.isExpanded,
  });

  String headerValue;
  dynamic expandedValue;
  bool isExpanded;
}





import 'package:color_blast/Controller/payment_controller.dart';
import 'package:color_blast/Page/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Animation/animation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


class BasketProductPage extends StatefulWidget {
  const BasketProductPage({Key? key}) : super(key: key);

  @override
  State<BasketProductPage> createState() => _BasketProductPageState();
}

class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

class _BasketProductPageState extends State<BasketProductPage> {
  List<Product> productList = [
    Product(name: 'Produit 1', price: 10.99),
    Product(name: 'Produit 2', price: 15.99),
    Product(name: 'Produit 3', price: 12.49),
    Product(name: 'Produit 4', price: 9.99),
  ];

  int selectedProductIndex = -1;


  @override
  Widget build(BuildContext context) {
    final paymentController = Get.put(PaymentController());
    double totalPrice = 0.0;
    for (var product in productList) {
      totalPrice += product.price;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Votre Panier'),
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
      body: Column(
        children: [
          SizedBox(height: 16),
          Text(
            'Prix total: ${totalPrice.toStringAsFixed(2)} €',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                return ListTile(
                  leading: Image.asset('assets/img.png'), // Remplacez 'assets/images/product_image.png' par le chemin de votre image
                  title: Text(product.name),
                  subtitle: Text('${product.price} €'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        selectedProductIndex = index;
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Supprimer le produit ?'),
                            content: Text('Êtes-vous sûr de vouloir supprimer ce produit de votre panier ?'),
                            actions: [
                              TextButton(
                                child: Text('Annuler'),
                                onPressed: () {
                                  setState(() {
                                    selectedProductIndex = -1;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Supprimer'),
                                onPressed: () {
                                  setState(() {
                                    productList.removeAt(selectedProductIndex);
                                    selectedProductIndex = -1;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),

          ElementAnimation(1.6,GestureDetector(
            onTap: () {
              paymentController.makePayment(amount: '5', currency: 'USD');
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.orange[900]
              ),
              child: Center(
                child: Text("Payer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
            ),
          )),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}

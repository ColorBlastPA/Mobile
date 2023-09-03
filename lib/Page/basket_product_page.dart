import 'package:color_blast/Controller/payment_controller.dart';
import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/panier.dart';
import 'package:color_blast/Page/product_details_page.dart';
import 'package:color_blast/Service/service_panier.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class BasketProductPage extends StatefulWidget {
  const BasketProductPage({Key? key}) : super(key: key);

  @override
  State<BasketProductPage> createState() => _BasketProductPageState();
}

class _BasketProductPageState extends State<BasketProductPage> {
  List<Panier?>? panier = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    panier = await ServicePanier().getPanierByIdClient(DataManager().client?.id);
    setState(() {
      isLoading = false;
    });
  }

  removeElement(int idPanier) async {
    await ServicePanier().removePanier(idPanier);
  }

  int selectedProductIndex = -1;

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.put(PaymentController());
    double totalPrice = 0.0;
    for (var panierItem in panier ?? []) {
      totalPrice += panierItem?.product?.price ?? 0.0;
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
          isLoading
              ? CircularProgressIndicator()
              : SizedBox(height: 16),
          Text(
            'Prix total: ${totalPrice.toStringAsFixed(2)} €',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: panier?.length ?? 0,
              itemBuilder: (context, index) {
                final panierItem = panier![index];
                return ListTile(
                  leading: panierItem?.product?.image != null && panierItem?.product?.image != ""
                      ? Image.network(
                    panierItem!.product!.image!,
                    width: 50,  // Largeur souhaitée
                    height: 50, // Hauteur souhaitée
                  )
                      : Image.asset(
                    'assets/img.png',
                    width: 50,  // Largeur souhaitée
                    height: 50, // Hauteur souhaitée
                  ),
                  title: Text(panierItem?.product?.name ?? ""),
                  subtitle: Text('${panierItem?.product?.price ?? 0.0} €'),
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
                            content: Text(
                                'Êtes-vous sûr de vouloir supprimer ce produit de votre panier ?'),
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
                                onPressed: () async {
                                  if (panierItem != null) {
                                    await removeElement(panierItem.idPanier);
                                    setState(() {
                                      panier!.removeAt(selectedProductIndex);
                                      selectedProductIndex = -1;
                                    });
                                  }
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
          GestureDetector(
            onTap: () {
              paymentController.makePayment(
                  amount: totalPrice, currency: 'USD');
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.orange[900]),
              child: Center(
                child: Text(
                  "Payer",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}

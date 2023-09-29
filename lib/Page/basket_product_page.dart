import 'dart:convert';
import 'dart:math';

import 'package:color_blast/Controller/payment_controller.dart';
import 'package:color_blast/Model/data_manager.dart';
import 'package:color_blast/Model/messagerie.dart';
import 'package:color_blast/Model/panier.dart';
import 'package:color_blast/Service/service_email.dart';
import 'package:color_blast/Service/service_order.dart';
import 'package:color_blast/Service/service_panier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;


import '../Controller/notification_service.dart';

class BasketProductPage extends StatefulWidget {
  const BasketProductPage({Key? key}) : super(key: key);

  @override
  State<BasketProductPage> createState() => _BasketProductPageState();
}

class _BasketProductPageState extends State<BasketProductPage> {
  List<Panier?>? panier = [];
  bool isLoading = true;

  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(
      {required double amount, required String currency}) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              //applePay: true,
              //googlePay: true,
              //testEnv: true,
              //merchantCountryCode: 'US',
              merchantDisplayName: 'Prospects',
              customerId: paymentIntentData!['customer'],
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
            ));
        displayPaymentSheet();
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Get.snackbar('Payment', 'Payment Successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2));

      await addOrder();
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        print("Unforeseen error: ${e}");
      }
    } catch (e) {
      print("exception:$e");
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(double amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer sk_test_51NIrKYCJoeQc9GZJr83rwag0vnJpjbkBKcaP8uyI5dz9Wir9nqDxs75KdeqTsFdHtk4xWXq0b5J27oXAPd9jjazR00wlfHM4Kp',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(double amount) {
    final a = (amount * 100).toInt();
    return a.toString();
  }

  @override
  void initState() {
    super.initState();
    getData();
    tz.initializeTimeZones();


  }

  getData() async {
    panier = await ServicePanier().getPanierByIdClient(DataManager().client?.id);
    setState(() {
      isLoading = false;
    });

  }

  Future<void> addOrder() async {
    var key = generateUuidV4();
    print("ICI");
    print(panier);
    for (Panier? panierItem in panier! ) {
      print(panierItem?.product.id);
      if (panierItem != null) {
        await ServiceOrder().createOrder(key, DataManager().client?.id, panierItem.product.id);
      }
      await removeElement(panierItem?.idPanier);
    }

    await ServiceEmail().getCommentProductEmail(DataManager().client?.mail, key);
    setState(() {
      NotificationService().showNotification(1, "ColorBlast", "Vos achats à bien été pris en compte. Vous allez recevoir un mail de satisfaction.", 3);

      panier?.clear();
    });

  }

  String generateUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (i) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0F) | 0x40;
    bytes[8] = (bytes[8] & 0x3F) | 0x80;
    final hexDigits = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
    return '${hexDigits.substring(0, 8)}-${hexDigits.substring(8, 12)}-${hexDigits.substring(12, 16)}-${hexDigits.substring(16, 20)}-${hexDigits.substring(20)}';
  }
  removeElement(int? idPanier) async {
    await ServicePanier().removePanier(idPanier);
  }

  int selectedProductIndex = -1;

  @override
  Widget build(BuildContext context) {

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
            child: panier == null || panier?.length == 0
                ? Center(
                  child: Text(
                "Vous n'avez aucun objet dans votre panier",
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: panier!.length,
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
              makePayment(
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



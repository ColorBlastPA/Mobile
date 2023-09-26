import 'package:color_blast/Model/booking.dart';
import 'package:color_blast/Model/messagerie.dart';
import 'package:color_blast/Service/service_booking.dart';
import 'package:color_blast/Service/service_messagerie.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:timezone/data/latest.dart' as tz;


import '../Controller/notification_service.dart';
import '../Model/client.dart';
import '../Model/data_manager.dart';
import '../Model/planning.dart';
import '../Model/product.dart';
import '../Model/professionnel.dart';
import '../Service/service_planning.dart';
import '../Service/service_product.dart';


class TakeMeetPage extends StatefulWidget {

  final Professionnel professionnel;
  TakeMeetPage({required this.professionnel});
  @override
  State<TakeMeetPage> createState() => _TakeMeetPageState();
}

class _TakeMeetPageState extends State<TakeMeetPage> {
  Client? client = DataManager().client;
  List<Planning?>? planning = [];
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _villeController = TextEditingController();
  TextEditingController _adresseController = TextEditingController();
  TextEditingController _surfaceController = TextEditingController();
  bool _isOutdoorSelected = false;
  bool _isIndoorSelected = false;
  bool _isLoadingProducts = true;
  List<Product> _selectedProducts = [];
  List<Product?>? products = [];
  List<PickerDateRange> _selectedDateRanges = [];
  List<PickerDateRange> selectedCache = [];
  final DateRangePickerController _datePickerController = DateRangePickerController();


  @override
  void initState() {
    super.initState();
    _firstNameController.text = client?.firstname ?? "";
    _lastNameController.text = client?.lastname ?? "";
    _villeController.text = client?.city ?? "";
    _adresseController.text = client?.address ?? "";
    getProduct();
    getPlanning();
    tz.initializeTimeZones();

  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _adresseController.dispose();
    _villeController.dispose();
    _surfaceController.dispose();
    super.dispose();
  }

  void getPlanning() async {
    planning = await ServicePlanning().getPlanningByIdPro(5005);

    List<PickerDateRange> selectedDateRanges = [];
    for (var planning in planning!) {
      PickerDateRange pickerDateRange = PickerDateRange(planning?.ddate, planning?.fdate);
      selectedDateRanges.add(pickerDateRange);
    }

    setState(() {
      _datePickerController.selectedRanges = selectedDateRanges;
    });
  }

  List<PickerDateRange> checkDateSelected(List<PickerDateRange>? selectedRanges) {
    List<PickerDateRange> checkDateSelected = [];

    if (selectedRanges != null) {
      for (var selectedRange in selectedRanges) {
        bool shouldAdd = true;
        for (var planningItem in this.planning!) {
          if (planningItem != null &&
              (selectedRange.startDate!.isAfter(planningItem.fdate) || selectedRange.endDate!.isBefore(planningItem.ddate))) {
            // Si la plage de dates sélectionnée ne chevauche pas une plage de planning, ajoutez-la
            continue;
          } else {
            // Sinon, ne l'ajoutez pas
            shouldAdd = false;
            break;
          }
        }
        if (shouldAdd) {
          checkDateSelected.add(selectedRange);
        }
      }
    }
    print(checkDateSelected.length);
    return checkDateSelected;
  }



  Future<void> getProduct() async {
    products = await ServiceProduct().getProductsByCategories(["EXTERN", "INTERN"]);
    setState(() {
      _isLoadingProducts = false;
    });
  }

  int getCategorie(){
    if(_isOutdoorSelected && !_isIndoorSelected){
      return 1;
    }else if(!_isOutdoorSelected && _isIndoorSelected){
      return 2;
    }else if((_isOutdoorSelected && _isIndoorSelected) || (!_isOutdoorSelected && !_isIndoorSelected)){
      return 3;
    }
    return 0;
  }

  Future<void> getDevis() async {
    if(_lastNameController.text == "" || _firstNameController.text == "" ||_villeController.text == "" || _adresseController.text == "" || _surfaceController.text == ""){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Information"),
            content: Text("Tous les champs doivent être remplis et valide !"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }else if(getCategorie() == 0){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Information"),
            content: Text("Vous devez choisir au moins un type de peinture !"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }else if(_selectedDateRanges.length != 1){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Information"),
            content: Text("Veuillez renseignez un intervalle de date !"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }else if(_selectedProducts.length == 0){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Information"),
            content: Text("Veuillez renseignez au moins un produit !"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }else{
      BookingClass bookingClass = BookingClass(id:1, idPro: widget.professionnel.id, lastname: _lastNameController.text, firstname: _firstNameController.text, city: _villeController.text, address: _adresseController.text, category: getCategorie(), surface: double.parse(_surfaceController.text), dhDebut: _selectedDateRanges.first.startDate!, dhFin: _selectedDateRanges.first.endDate!, waiting: true, idClient: DataManager().client!.id);
      var response = await ServiceBooking().createBooking(bookingClass);
      if(response.statusCode == 200){
        bookingClass = bookingClassFromJson(response.body);
        for (var product in _selectedProducts) {
            await ServiceBooking().createProductBooking(bookingClass.id, product.id);
        }
        MessagerieClass messagerieClass = MessagerieClass(id: 1, idClient: DataManager().client!.id, idPro: widget.professionnel.id, lastMessage: "Nouvelle discussion", dLastMessage: DateTime.now(), dlastMessage: DateTime.now());
        var responseMessagerie = await ServiceMessagerie().createMessagerie(messagerieClass);
        if(responseMessagerie == 409){
          NotificationService().showNotification(1, "ColorBlast", "Votre demande à bien été pris en compte.", 3);

        }else{
          NotificationService().showNotification(1, "ColorBlast", "Votre demande à bien été pris en compte. Une messagerie à été créer avec le professionnel.", 3);
        }

        Navigator.of(context).pop();
      }else{
        print("erreur");
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informations Rendez-vous"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'Votre nom:',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ),
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Votre Prénom:',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ),
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _villeController,
                        decoration: InputDecoration(
                          labelText: 'Votre ville:',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ),
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _adresseController,
                        decoration: InputDecoration(
                          labelText: 'Votre Adresse:',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ),
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Checkbox(
                    value: _isOutdoorSelected,
                    onChanged: (value) {
                      setState(() {
                        _isOutdoorSelected = value!;
                      });
                    },
                  ),
                  Text('Extérieur'),
                  SizedBox(width: 20),
                  Checkbox(
                    value: _isIndoorSelected,
                    onChanged: (value) {
                      setState(() {
                        _isIndoorSelected = value!;
                      });
                    },
                  ),
                  Text('Intérieur'),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Text('Surface:'),
                  SizedBox(width: 10),
                  Container(
                    width: 120,
                    child: TextField(
                      controller: _surfaceController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.none,
                      decoration: InputDecoration(
                        hintText: 'Entrez la surface',
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('m²'),
                ],
              ),
              SizedBox(height: 25),
              if (_isLoadingProducts)
                CircularProgressIndicator(), // Affichez le spinner si les produits sont en cours de chargement
              if (!_isLoadingProducts) // Affichez le formulaire lorsque les produits sont chargés
                MultiSelectFormField(
                  title: Text('Sélectionnez des produits'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner au moins un élément';
                    }
                    return null;
                  },
                  dataSource: products != null
                      ? products
                      ?.where((product) {
                    if ((_isOutdoorSelected && _isIndoorSelected) ||
                        (!_isOutdoorSelected && !_isIndoorSelected)) {
                      return true;
                    } else if (_isOutdoorSelected) {
                      return product?.category == "EXTERN";
                    } else if (_isIndoorSelected) {
                      return product?.category == "INTERN";
                    }
                    return false;
                  })
                      ?.map((product) => {
                    "display": "${product?.name} - Prix: ${product?.price} €",
                    "value": product,
                  })
                      .toList()
                      : [],
                  textField: 'display',
                  valueField: 'value',
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'Annuler',
                  initialValue: _selectedProducts,
                  onSaved: (value) {
                    setState(() {
                      _selectedProducts = value.cast<Product>();
                    });
                  },
                ),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final List<PickerDateRange>? pickedDateRanges = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Sélectionnez des dates"),
                              content: SfDateRangePicker(
                                view: DateRangePickerView.month,
                                selectionMode: DateRangePickerSelectionMode.multiRange,
                                controller: _datePickerController,
                                showActionButtons: false,
                                onCancel: () {
                                  _datePickerController.selectedRanges = null;
                                },
                                monthCellStyle: const DateRangePickerMonthCellStyle(
                                  textStyle: TextStyle(
                                    color: Colors.black, // Couleur du texte du mois
                                    fontSize: 16.0, // Taille de la police du mois
                                  ),
                                  todayTextStyle: TextStyle(
                                    color: Colors.blue, // Couleur du texte pour la date d'aujourd'hui
                                    fontWeight: FontWeight.bold, // Gras pour la date d'aujourd'hui
                                  ),
                                  disabledDatesTextStyle: TextStyle(
                                    color: Colors.grey, // Couleur du texte pour les dates désactivées
                                  ),
                                ),
                                yearCellStyle: const DateRangePickerYearCellStyle(
                                  textStyle: TextStyle(
                                    color: Colors.black, // Couleur du texte de l'année
                                    fontSize: 16.0, // Taille de la police de l'année
                                  ),
                                ),
                              ),
                                actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, checkDateSelected(_datePickerController.selectedRanges));
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );

                        if (pickedDateRanges != null) {
                          setState(() {
                            _selectedDateRanges = pickedDateRanges;
                          });
                        }
                      },
                      child: Text('Sélectionner une date'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),

              Column(
                children: [
                  Text(
                    'Dates sélectionnées:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (_selectedDateRanges.length > 0)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _selectedDateRanges?.length,
                      itemBuilder: (context, index) {
                        final dateRange = _selectedDateRanges![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Période ${index + 1}: ${dateRange.startDate?.toLocal()} - ${dateRange.endDate?.toLocal()}',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    ),
                  if (_selectedDateRanges.length > 1)
                    Text("Vous ne pouvez sélectionner qu'une seule période !!"),
                  if (_selectedDateRanges.isEmpty)
                    Text("Veuillez renseignez au moins une date et non prise par le professionnel !!")
                ],
              ),

              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        getDevis();
                      },
                      child: Text('Faire un devis'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

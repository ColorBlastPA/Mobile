import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:intl/intl.dart';



class TakeMeetPage extends StatefulWidget {
  const TakeMeetPage({Key? key}) : super(key: key);

  @override
  State<TakeMeetPage> createState() => _TakeMeetPageState();
}

class _TakeMeetPageState extends State<TakeMeetPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _villeController = TextEditingController();
  TextEditingController _adresseController = TextEditingController();
  TextEditingController _surfaceController = TextEditingController();


  bool _isOutdoorSelected = false;
  bool _isIndoorSelected = false;


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _adresseController.dispose();
    _villeController.dispose();
    _surfaceController.dispose();
    super.dispose();
  }
  List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  List<String> _selectedItems = [];
  DateTime? _startDate;
  DateTime? _endDate;




  void _showSelectionModal() async {
    final selectedItems = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sélectionnez des éléments'),
          content: MultiSelectFormField(
            chipBackGroundColor: Colors.blue,
            chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
            checkBoxActiveColor: Colors.blue,
            checkBoxCheckColor: Colors.white,
            dialogShapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            title: Text(
              'Éléments',
              style: TextStyle(fontSize: 16),
            ),
            dataSource: items.map((item) {
              return {'display': item, 'value': item};
            }).toList(),
            textField: 'display',
            valueField: 'value',
            okButtonLabel: 'OK',
            cancelButtonLabel: 'ANNULER',
            hintWidget: Text('Sélectionnez des éléments'),
            initialValue: _selectedItems,
            onSaved: (values) {
              if (values == null) return;
              setState(() {
                _selectedItems = List<String>.from(values);
              });
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(_selectedItems);
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );

    if (selectedItems != null) {
      setState(() {
        _selectedItems = selectedItems;
      });
    }
  }

  Future<void> _selectDateRange() async {
    final pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDateRange != null) {
      setState(() {
        _startDate = pickedDateRange.start;
        _endDate = pickedDateRange.end;
      });
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
                    width: 120, // Définir la largeur souhaitée pour la zone éditable
                    child: TextField(
                      controller: _surfaceController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.none, // Empêche le clavier d'afficher les actions
                      decoration: InputDecoration(
                        hintText: 'Entrez la surface',
                      ),
                      style: TextStyle(fontSize: 14), // Ajuster la taille de police du texte éditable
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('m²'),
                ],
              ),
              SizedBox(height: 25),
              Text(
                'Produits sélectionnés: ${_selectedItems.join(", ")}',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: _showSelectionModal,
                child: Text('Sélectionner des produits'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent), // Couleur de fond lorsque le bouton est dans son état par défaut
                ),
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectDateRange,
                      child: Text('Sélectionner une date'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent), // Couleur de fond lorsque le bouton est dans son état par défaut
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              if (_startDate != null && _endDate != null)
                Text(
                  'Date de début: ${DateFormat('dd/MM/yyyy').format(_startDate!)}\nDate de fin: ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Logique pour le bouton "Valider"
                      },
                      child: Text('Valider'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent), // Couleur de fond lorsque le bouton est dans son état par défaut
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Espacement entre les boutons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Logique pour le bouton "Faire un devis"
                      },
                      child: Text('Faire un devis'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent), // Couleur de fond lorsque le bouton est dans son état par défaut
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

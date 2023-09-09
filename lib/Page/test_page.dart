import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class testPage extends StatefulWidget {
  const testPage({Key? key}) : super(key: key);

  @override
  State<testPage> createState() => _testPageState();
}

class _testPageState extends State<testPage> {

  DateRangePickerController _datePickerController = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SfDateRangePicker(
            view: DateRangePickerView.month,
            monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 6),
            selectionMode: DateRangePickerSelectionMode.multiRange,
            //onSelectionChanged: _onSelectionChanged,
            showActionButtons: true,
            controller: _datePickerController,

            onCancel: () {
              _datePickerController.selectedRanges = null;
            },
          ),
        ),
    );
  }
}

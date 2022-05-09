import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:sft/calculation.dart';
import 'package:sft/db/database.dart';
import 'package:sft/modal/vehicle.dart';

import 'custom_textfield.dart';

class vehicleScreenBody extends StatefulWidget {
  const vehicleScreenBody({Key? key, required this.vehicle}) : super(key: key);

  final Vehicle vehicle;

  @override
  State<vehicleScreenBody> createState() => _vehicleScreenBodyState();
}

class _vehicleScreenBodyState extends State<vehicleScreenBody> {
  double distanceTraveled = 0;
  double fuel = 0;
  double remainingFuel = 0;
  double estimatedDistance = 0;
  TextEditingController fuelController = TextEditingController();
  TextEditingController distanceTraveledController = TextEditingController();

  Vehicle? selectedvehicle;

  @override
  void initState() {
    super.initState();
    selectedvehicle = widget.vehicle;
    remainingFuel = selectedvehicle!.remainingFuel;
    estimatedDistance = selectedvehicle!.estimatedDistance;
  }

  @override
  Widget build(BuildContext context) {
    if (selectedvehicle == null) {
      return CircularProgressIndicator();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text('Details of vehicle'),
                        content: Wrap(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name: " + selectedvehicle!.name),
                                SizedBox(height: 5),
                                Text("Capacity: " +
                                    selectedvehicle!.capacity.toString()),
                                SizedBox(height: 5),
                                Text("Mileage: " +
                                    selectedvehicle!.mileage.toString()),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.info),
              ),
            ],
          ),
          _petrolLevel(),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Can travel upto',
              style: GoogleFonts.openSans(
                fontSize: 17,
                color: Colors.grey.shade900,
              ),
            ),
          ),
          SizedBox(height: 5),
          estimatedDistanceProgressbar(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select vehicle',
                style: GoogleFonts.openSans(
                  fontSize: 17,
                  color: Colors.grey.shade900,
                ),
              ),
              // _customDropdownList(),
            ],
          ),
          SizedBox(height: 10),
          columnOfHeadingInputField(
              controller: fuelController,
              title: 'Enter Fuel you Charged before',
              hint: '0 to ${selectedvehicle!.capacity}',
              suffix: 'litre',
              onChanged: (newVal) {
                setState(() {
                  fuel = double.parse(newVal.trim());
                });
              }),
          SizedBox(height: 10),
          columnOfHeadingInputField(
              controller: distanceTraveledController,
              title: 'Distance Traveled',
              hint: '10',
              suffix: 'kilometer',
              onChanged: (newVal) {
                distanceTraveled = double.parse(newVal.trim());
              }),
          SizedBox(height: 20),
          InkWell(
            onTap: () async {
              if (fuelController.text.isNotEmpty &&
                  distanceTraveledController.text.isNotEmpty &&
                  (double.parse(fuelController.text) <=
                      selectedvehicle!.capacity)) {
                FocusScope.of(context).unfocus();
                setState(() {
                  remainingFuel = Calculation.calculateRemainingFuel(
                    fuel: fuel + selectedvehicle!.remainingFuel,
                    mileage: selectedvehicle!.mileage,
                    distanceTravelled: distanceTraveled,
                  );

                  estimatedDistance = Calculation.estimatedDistanceCanTravel(
                    fuel: remainingFuel,
                    mileage: selectedvehicle!.mileage,
                    distanceTravelled: remainingFuel,
                  );
                  print(estimatedDistance);
                });
                selectedvehicle = selectedvehicle!.copy(
                  remainingFuel: remainingFuel,
                  estimatedDistance: estimatedDistance,
                );
                await DatabaseHelper.updateRemainingFuelAndEstimatedDistance(
                    selectedvehicle!);
              } else if (double.parse(fuelController.text) >=
                  selectedvehicle!.capacity) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Capacity of your vehicle is ${selectedvehicle!.capacity}, Enter value below it '),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Enter Values ')),
                );
              }
            },
            child: _calculateButton(context),
          ),
        ],
      ),
    );
  }

  FAProgressBar estimatedDistanceProgressbar() {
    int dis = (selectedvehicle!.capacity * selectedvehicle!.mileage).toInt();
    int estimatedDis = estimatedDistance.toInt();

    return FAProgressBar(
      displayTextStyle: GoogleFonts.openSans(
        color: Colors.black,
      ),
      animatedDuration: Duration(milliseconds: 1000),
      maxValue: dis,
      progressColor: Colors.red.shade400,
      backgroundColor: Colors.red.shade100,
      currentValue: estimatedDis < 0 ? 0 : estimatedDis,
      displayText: 'km',
    );
  }

  SizedBox _petrolLevel() {
    return SizedBox(
      height: 200,
      width: 200,
      child: LiquidCircularProgressIndicator(
        value: (remainingFuel / selectedvehicle!.capacity),
        valueColor: AlwaysStoppedAnimation(Colors.yellow),
        backgroundColor: Colors.white,
        borderColor: Color(0xFF002B30),
        borderWidth: 3.0,
        direction: Axis.vertical,
        center: Text(
          (remainingFuel).toStringAsFixed(2) + ' litre',
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  // Container _customDropdownList() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     decoration: BoxDecoration(
  //       color: Colors.grey.shade200,
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: DropdownButton(
  //       itemHeight: 60,
  //       isDense: true,
  //       value: selectedvehicle!.id,
  //       style: GoogleFonts.openSans(
  //         color: Colors.grey.shade900,
  //       ),
  //       items: widget.vehicles
  //           .map((e) => DropdownMenuItem(
  //                 value: e.id,
  //                 child: Text(e.name),
  //               ))
  //           .toList(),
  //       onChanged: (newValue) async {
  //         selectedvehicle =
  //             await DatabaseHelper.getvehicleById(newValue as int);
  //         setState(() {
  //           // selectedvehicle =
  //           //     widget.vehicles.firstWhere((element) => element.id == newValue);
  //           remainingFuel = selectedvehicle!.remainingFuel;
  //           estimatedDistance = selectedvehicle!.estimatedDistance;
  //         });
  //       },
  //     ),
  //   );
  // }

  Container _calculateButton(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          'Calculate',
          style: GoogleFonts.openSans(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sft/db/database.dart';
import 'package:sft/modal/vehicle.dart';
import 'package:sft/screens/add_vehicle.dart';
import 'package:sft/screens/vehicle_screen.dart';

class vehiclesScreen extends StatefulWidget {
  const vehiclesScreen({Key? key}) : super(key: key);

  @override
  State<vehiclesScreen> createState() => _vehiclesScreenState();
}

class _vehiclesScreenState extends State<vehiclesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text('SFT'),
              centerTitle: true,
              elevation: 1.5,
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.white,
              onPressed: () async {
                FocusScope.of(context).unfocus();
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Addvehicle();
                  },
                );
                setState(() {});
              },
              label: Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 25,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Add new vehicle',
                      style: GoogleFonts.openSans(
                        color: Colors.blueAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: FutureBuilder<List<Vehicle>>(
                future: DatabaseHelper.getAllvehicle(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData && snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<Vehicle> vehicles = snapshot.data!;
                  if (vehicles.isEmpty) {
                    return Center(child: Text('Add vehicle Below'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () async {
                          await showDialog(
                              context: context,
                              builder: (cnt) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey.shade100,
                                  title: Text(
                                    "Are sure to Delete ?",
                                    style: GoogleFonts.openSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  actionsPadding: EdgeInsets.all(20),
                                  actions: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          primary: Colors.grey.shade200,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(cnt);
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: GoogleFonts.openSans(
                                            fontSize: 15,
                                            color: Colors.grey.shade900,
                                          ),
                                        )),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          primary:
                                              Color.fromARGB(255, 224, 83, 81)),
                                      onPressed: () async {
                                        await DatabaseHelper.deletevehicleById(
                                            vehicles[index].id!);
                                        Navigator.pop(cnt);
                                      },
                                      child: Text(
                                        'Delete',
                                        style: GoogleFonts.openSans(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                          setState(() {});
                        },
                        onTap: () async {
                          Vehicle svehicle =
                              await DatabaseHelper.getvehicleById(
                                  vehicles[index].id!);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return vehicleScreen(vehicle: svehicle);
                            },
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 33, 79, 171),
                                  Color.fromARGB(255, 124, 215, 248),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: Offset(0, 4),
                                )
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 170,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vehicles[index].name,
                                  style: GoogleFonts.openSans(
                                    fontSize: 27,
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Capacity: " +
                                          vehicles[index]
                                              .capacity
                                              .toStringAsFixed(1),
                                      style: GoogleFonts.openSans(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Remaining Fuel: " +
                                          vehicles[index]
                                              .remainingFuel
                                              .toStringAsFixed(2),
                                      style: GoogleFonts.openSans(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:sft/db/database.dart';
import 'package:sft/modal/vehicle.dart';
import 'package:sft/screens/vehicle_screen.dart';
import 'package:sft/screens/vehicles_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preDefinedvehicles();
  runApp(const MyApp());
}

preDefinedvehicles() async {
  final sp = await SharedPreferences.getInstance();
  if (sp.getBool('isFirstTime') == null || sp.getBool('isFirstTime') == true) {
    List<Vehicle> vehicles = [
      Vehicle(name: 'Activa 6g', mileage: 55, capacity: 5),
      Vehicle(name: 'Splender', mileage: 82, capacity: 11),
      // vehicle(name: 'Aprilia Strom 125', mileage: 40, capacity: 6),
      // vehicle(name: 'R15 V3', mileage: 49, capacity: 11),
      // vehicle(name: 'KTM Duke 125', mileage: 40, capacity: 11),
    ];
    for (var vehicle in vehicles) {
      await DatabaseHelper.insert(vehicle);
    }
    sp.setBool('isFirstTime', false);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const vehiclesScreen(),
    );
  }
}

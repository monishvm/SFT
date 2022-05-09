import 'package:flutter/material.dart';
import 'package:sft/db/database.dart';
import 'package:sft/modal/vehicle.dart';
import 'package:sft/screens/add_vehicle.dart';
import 'package:sft/widgets/vehicle_screen_body.dart';

class vehicleScreen extends StatefulWidget {
  const vehicleScreen({Key? key, required this.vehicle}) : super(key: key);

  final Vehicle vehicle;

  @override
  State<vehicleScreen> createState() => _vehicleScreenState();
}

class _vehicleScreenState extends State<vehicleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle.name),
        centerTitle: true,
        elevation: 1.5,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: vehicleScreenBody(vehicle: widget.vehicle),
          ),
        ),
      ),
    );
  }
}

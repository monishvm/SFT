import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sft/db/database.dart';
import 'package:sft/modal/vehicle.dart';
import 'package:sft/widgets/custom_textfield.dart';

class Addvehicle extends StatefulWidget {
  const Addvehicle({Key? key}) : super(key: key);

  @override
  State<Addvehicle> createState() => _AddvehicleState();
}

class _AddvehicleState extends State<Addvehicle> {
  late String name;

  late double mileage;

  late double capacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add New vehicle',
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              columnOfHeadingInputField(
                  title: 'vehicle Name',
                  hint: 'Activa',
                  suffix: '',
                  isname: true,
                  onChanged: (newV) {
                    name = newV;
                  }),
              SizedBox(height: 10),
              columnOfHeadingInputField(
                  title: 'Mileage',
                  hint: '25',
                  suffix: 'kilometer/litre',
                  onChanged: (newVal) {
                    mileage = double.parse(newVal);
                  }),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: columnOfHeadingInputField(
                    title: 'Capacity',
                    hint: '5',
                    suffix: 'litre',
                    onChanged: (newV) {
                      capacity = double.parse(newV);
                    }),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  print(name);

                  if (name.isNotEmpty &&
                      mileage.toString().isNotEmpty &&
                      capacity.toString().isNotEmpty) {
                    await DatabaseHelper.insert(
                      Vehicle(
                        name: name.trim(),
                        mileage: mileage,
                        capacity: capacity,
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Save',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

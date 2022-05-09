import 'package:sft/db/database.dart';

class Vehicle {
  final int? id;
  final String name;
  final double mileage;
  final double capacity;
  final double remainingFuel;
  final double estimatedDistance;

  Vehicle({
    this.id,
    required this.name,
    required this.mileage,
    required this.capacity,
    this.remainingFuel = 0,
    this.estimatedDistance = 0,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json[DatabaseHelper.id],
      name: json[DatabaseHelper.name],
      mileage: json[DatabaseHelper.mileage],
      capacity: json[DatabaseHelper.capacity],
      remainingFuel: json[DatabaseHelper.remaining_fuel],
      estimatedDistance: json[DatabaseHelper.estimated_distance],
    );
  }

  Vehicle copy({
    int? id,
    String? name,
    double? mileage,
    double? capacity,
    double? remainingFuel,
    double? estimatedDistance,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      mileage: mileage ?? this.mileage,
      capacity: capacity ?? this.capacity,
      remainingFuel: remainingFuel ?? this.remainingFuel,
      estimatedDistance: estimatedDistance ?? this.estimatedDistance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      DatabaseHelper.id: id,
      DatabaseHelper.name: name,
      DatabaseHelper.mileage: mileage,
      DatabaseHelper.capacity: capacity,
      DatabaseHelper.remaining_fuel: remainingFuel,
      DatabaseHelper.estimated_distance: estimatedDistance,
    };
  }
}

class Calculation {
  static double calculateRemainingFuel({
    required double fuel,
    required double mileage,
    required double distanceTravelled,
  }) {
    final remainingFuel = fuel - (distanceTravelled / mileage);
    return remainingFuel > 0 ? remainingFuel : 0;
  }

  static double estimatedDistanceCanTravel({
    required double fuel,
    required double mileage,
    required double distanceTravelled,
  }) {
    return  (fuel * mileage) - distanceTravelled;
  }

  static ddFuel() {}
}
